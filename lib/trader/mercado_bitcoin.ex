defmodule Trader.MercadoBitcoin do
  use GenServer

  require Logger

  alias Trader.MercadoBitcoin.{Ticker, Trade}

  def start_link(params) do
    HTTPoison.start()

    GenServer.start_link(__MODULE__, [], name: __MODULE__)
    :timer.send_interval(1000, __MODULE__, params)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_info({:ticker, symbol}, state) do
    {:ok, base_url} = Application.fetch_env(:trader, :mercado_bitcoin_base_url)

    %HTTPoison.Response{
      body: body
    } = HTTPoison.get!("#{base_url}#{symbol}/ticker")

    %{"ticker" => ticker} = Jason.decode!(body)

    ticker = %Ticker{
      symbol: symbol,
      date: ticker["date"],
      last_price: ticker["last"],
      high_price: ticker["high"],
      low_price: ticker["low"],
      volume: ticker["vol"],
      buy: ticker["buy"],
      sell: ticker["sell"]
    }

    Logger.info(
      "\n@ticker: #{ticker.symbol}\nLast price: #{Number.Currency.number_to_currency(ticker.last_price)}\nHigh price: #{Number.Currency.number_to_currency(ticker.high_price)}\nLow price: #{Number.Currency.number_to_currency(ticker.low_price)}\nVolume: #{ticker.volume}\nBuy: #{Number.Currency.number_to_currency(ticker.buy)}\nSell: #{Number.Currency.number_to_currency(ticker.sell)}"
    )

    {:noreply, state}
  end

  @impl true
  def handle_info({:trades, symbol}, state) do
    {:ok, base_url} = Application.fetch_env(:trader, :mercado_bitcoin_base_url)

    %HTTPoison.Response{
      body: body
    } = HTTPoison.get!("#{base_url}#{symbol}/trades")

    trades = Jason.decode!(body)

    Enum.map(trades, fn trade ->
      trade = %Trade{
        amount: trade["amount"],
        date: trade["date"],
        price: trade["price"],
        tid: trade["tid"],
        type: trade["type"]
      }

      Logger.info(
        "\n@trade #{symbol}\nAmount: #{Number.Currency.number_to_currency(trade.amount)}\nPrice: #{Number.Currency.number_to_currency(trade.price)}\nTID: #{trade.tid}\nType: #{trade.type}"
      )
    end)

    {:noreply, state}
  end
end
