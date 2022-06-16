defmodule Trader.Binance do
  use WebSockex

  require Logger

  alias Trader.Binance.{Trade, Ticker}

  defp via_tuple({event_type, symbol}) do
    {:via, Registry, {:binance_workers, "#{symbol}@#{event_type}"}}
  end

  def start_link({event_type, symbol}) do
    {:ok, base_url} = Application.fetch_env(:trader, :binance_stream_base_url)

    IO.puts("#{base_url}#{symbol}#{event_type}")

    WebSockex.start_link(
      "#{base_url}#{symbol}#{event_type}",
      __MODULE__,
      %{
        event_type: event_type,
        symbol: symbol
      },
      name: via_tuple({event_type, symbol})
    )
  end

  def handle_frame({_type, msg}, state) do
    case Jason.decode(msg) do
      {:ok, event} -> process_event(event)
      {:error, err} -> {:error, err}
    end

    {:ok, state}
  end

  defp process_event(%{"e" => "trade"} = event) do
    trade = %Trade{
      :event_type => event["e"],
      :event_time => event["E"],
      :symbol => event["s"],
      :trade_id => event["t"],
      :price => event["p"],
      :quantity => event["q"],
      :buyer_order_id => event["b"],
      :seller_order_id => event["a"],
      :trade_time => event["T"],
      :buy_market_maker => event["m"]
    }

    Logger.info(
      "\n@trade: #{trade.symbol}\nID: #{trade.trade_id}\nPrice: #{Number.Currency.number_to_currency(trade.price)}\nQuantity: #{trade.quantity}\nBuyer Order ID: #{trade.buyer_order_id}\nSeller Order ID: #{trade.seller_order_id}\nTrade Time: #{trade.trade_time}\nBuy Market Maker: #{trade.buy_market_maker}"
    )
  end

  defp process_event(%{"e" => "24hrMiniTicker"} = event) do
    ticker = %Ticker{
      :event_type => event["e"],
      :event_time => event["E"],
      :symbol => event["s"],
      :open_price => event["o"],
      :close_price => event["c"],
      :high_price => event["h"],
      :low_price => event["l"],
      :base_volume => event["v"],
      :quote_volume => event["q"]
    }

    Logger.info(
      "\n@ticker: #{ticker.symbol}\nOpen price: #{Number.Currency.number_to_currency(ticker.open_price)}\nClose price: #{Number.Currency.number_to_currency(ticker.close_price)}\nHigh price: #{Number.Currency.number_to_currency(ticker.high_price)}\nLow price: #{Number.Currency.number_to_currency(ticker.low_price)}\nBase volume: #{ticker.base_volume}\nQuote volume: #{ticker.quote_volume}"
    )
  end
end
