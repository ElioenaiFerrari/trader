defmodule Trader do
  @moduledoc """
  Trader is a simple trading bot to trade cryptocurrencies.

  Supported platforms:
  - Binance
  - Mercado Bitcoin
  """
  require Logger

  alias Trader.{Binance, MercadoBitcoin, Repo.Symbols}

  @doc """
  The function to initialize with application configuration.
  init is called to get all saved symbols and start the bot.
  """
  def init do
    symbols = Symbols.list()

    Enum.each(symbols, fn %{event_type: event_type, platform: platform, symbol: symbol} ->
      case event_type do
        "trades" -> trades({String.to_atom(platform), symbol})
        "ticker" -> ticker({String.to_atom(platform), symbol})
        _ -> Logger.warn("@Trader - Unknown event type: #{event_type}")
      end
    end)
  end

  @doc """
  The function to get trades for a symbol.
  Platform: Binance

  ## Examples
  ```elixir
    iex(2)> Trader.trades({:binance, "neousdt"})

    17:58:46.825 [info] @Binance - Starting link for trades for neousdt

    17:58:46.907 [debug] QUERY OK db=4.0ms idle=1981.3ms
    INSERT INTO "symbols" ("event_type","platform","symbol","inserted_at","updated_at","id") VALUES (?,?,?,?,?,?) ON CONFLICT ("symbol","platform","event_type") DO UPDATE SET "id" = EXCLUDED."id","symbol" = EXCLUDED."symbol","platform" = EXCLUDED."platform","event_type" = EXCLUDED."event_type","inserted_at" = EXCLUDED."inserted_at","updated_at" = EXCLUDED."updated_at" ["trades", "binance", "neousdt", "2022-06-16T20:58:46", "2022-06-16T20:58:46", "411c944f-c7f7-4fc3-aa43-4da54c114e78"]
    wss://stream.binance.com:9443/ws/neousdt@trade
    {:ok, #PID<0.352.0>}
    iex(2)>
    17:59:09.036 [info]
    @trade: NEOUSDT
    ID: 83130116
    Price: 9,01
    Quantity: 4.00000000
    Buyer Order ID: 970062557
    Seller Order ID: 970062870
    Trade Time: 1655413149245
    Buy Market Maker: true
  ```
  """

  def trades({:binance, symbol}) do
    Logger.info("@Binance - Starting link for trades for #{symbol}")

    Symbols.add(%{
      symbol: symbol,
      platform: "binance",
      event_type: "trades"
    })

    symbol
    |> String.downcase()
    |> Binance.DynamicSupervisor.trades()
  end

  @doc """
  The function to get ticker for a symbol.
  Platform: Binance

  ## Examples
  ```elixir
    iex(2)> Trader.ticker({:binance, "neousdt"})

    18:01:54.533 [info] @Binance - Starting link for ticker for neousdt

    18:01:54.535 [debug] QUERY OK db=1.1ms queue=0.1ms idle=1366.6ms
    INSERT INTO "symbols" ("event_type","platform","symbol","inserted_at","updated_at","id") VALUES (?,?,?,?,?,?) ON CONFLICT ("symbol","platform","event_type") DO UPDATE SET "id" = EXCLUDED."id","symbol" = EXCLUDED."symbol","platform" = EXCLUDED."platform","event_type" = EXCLUDED."event_type","inserted_at" = EXCLUDED."inserted_at","updated_at" = EXCLUDED."updated_at" ["ticker", "binance", "neousdt", "2022-06-16T21:01:54", "2022-06-16T21:01:54", "17bac7e6-c548-4fd1-8bf8-0d4d552e46c9"]
    wss://stream.binance.com:9443/ws/neousdt@miniTicker
    {:ok, #PID<0.363.0>}
    iex(3)>
    18:02:03.004 [info]
    @ticker: NEOUSDT
    Open price: 9,35
    Close price: 9,00
    High price: 10,19
    Low price: 8,79
    Base volume: 1025234.81000000
    Quote volume: 9676822.44920000
  ```
  """
  def ticker({:binance, symbol}) do
    Logger.info("@Binance - Starting link for ticker for #{symbol}")

    Symbols.add(%{
      symbol: symbol,
      platform: "binance",
      event_type: "ticker"
    })

    symbol
    |> String.downcase()
    |> Binance.DynamicSupervisor.ticker()
  end

  @doc """
  The function to get trades for a symbol.
  Platform: Mercado Bitcoin

  ## Examples
  ```elixir
    iex(2)> Trader.trades({:mercado_bitcoin, "btc"})

    18:03:47.837 [info]
    @trade btc
    Amount: 0,00
    Price: 106.150,00
    TID: 13809831
    Type: sell

    18:03:47.837 [info]
    @trade btc
    Amount: 0,00
    Price: 106.227,12
    TID: 13809832
    Type: buy

    18:03:47.837 [info]
    @trade btc
    Amount: 0,00
    Price: 106.227,12
    TID: 13809833
    Type: buy
  """
  def trades({:mercado_bitcoin, symbol}) do
    Logger.info("@MercadoBitcoin - Starting link for trades for #{symbol}")

    Symbols.add(%{
      symbol: symbol,
      platform: "mercado_bitcoin",
      event_type: "trades"
    })

    symbol
    |> String.downcase()
    |> MercadoBitcoin.DynamicSupervisor.trades()
  end

  @doc """
  The function to get ticker for a symbol.
  Platform: Mercado Bitcoin

  ## Examples
  ```elixir
    iex(2)> Trader.ticker({:mercado_bitcoin, "btc"})

    18:04:10.013 [info] @MercadoBitcoin - Starting link for ticker for btc

    18:04:10.098 [debug] QUERY OK db=0.6ms idle=585.8ms
    INSERT INTO "symbols" ("event_type","platform","symbol","inserted_at","updated_at","id") VALUES (?,?,?,?,?,?) ON CONFLICT ("symbol","platform","event_type") DO UPDATE SET "id" = EXCLUDED."id","symbol" = EXCLUDED."symbol","platform" = EXCLUDED."platform","event_type" = EXCLUDED."event_type","inserted_at" = EXCLUDED."inserted_at","updated_at" = EXCLUDED."updated_at" ["ticker", "mercado_bitcoin", "btc", "2022-06-16T21:04:10", "2022-06-16T21:04:10", "1784f08e-7698-49d7-8502-94274e2695fd"]
    {:error, {:ok, {:interval, #Reference<0.201370367.1634992132.187720>}}}
    iex(2)>
    18:04:11.495 [info]
    @ticker: btc
    Last price: 106.260,03
    High price: 116.400,00
    Low price: 105.378,81
    Volume: 82.10017459
    Buy: 106.260,03
    Sell: 106.260,03
  ```
  """
  def ticker({:mercado_bitcoin, symbol}) do
    Logger.info("@MercadoBitcoin - Starting link for ticker for #{symbol}")

    Symbols.add(%{
      symbol: symbol,
      platform: "mercado_bitcoin",
      event_type: "ticker"
    })

    symbol
    |> String.downcase()
    |> MercadoBitcoin.DynamicSupervisor.ticker()
  end

  @doc """
  This function stop a especific platform symbol events and delete of the database.

  ## Examples
  ```elixir
    iex(2)> Trader.ticker({:mercado_bitcoin, "btc"})

    18:06:12.796 [info] @MercadoBitcoin - Starting link for ticker for btc

    18:06:12.880 [debug] QUERY OK db=0.4ms idle=1638.6ms
    INSERT INTO "symbols" ("event_type","platform","symbol","inserted_at","updated_at","id") VALUES (?,?,?,?,?,?) ON CONFLICT ("symbol","platform","event_type") DO UPDATE SET "id" = EXCLUDED."id","symbol" = EXCLUDED."symbol","platform" = EXCLUDED."platform","event_type" = EXCLUDED."event_type","inserted_at" = EXCLUDED."inserted_at","updated_at" = EXCLUDED."updated_at" ["ticker", "binance", "btc", "2022-06-16T21:06:12", "2022-06-16T21:06:12", "32c0e457-d0b1-40bc-aef7-4b561256792a"]
    {:ok, #PID<0.354.0>}

    iex(3)> Trader.stop({:mercado_bitcoin, :trades, "btc"})

    18:06:36.634 [info] @MercadoBitcoin - Stopping link for trades for btc

    18:06:36.640 [debug] QUERY OK source="symbols" db=0.4ms queue=0.1ms idle=1394.4ms
    DELETE FROM "symbols" AS s0 WHERE (((s0."symbol" = ?) AND (s0."platform" = ?)) AND (s0."event_type" = ?)) ["btc", "mercado_bitcoin", "trades"]

    18:06:36.640 [warning] @MercadoBitcoin - No worker found for trades btc
    {:ok, {"trades", "btc"}}
    iex(4)> Trader.stop({:mercado_bitcoin, :trades, "btc"})

    18:06:38.381 [info] @MercadoBitcoin - Stopping link for trades for btc

    18:06:38.383 [debug] QUERY OK source="symbols" db=0.7ms queue=0.1ms idle=1137.2ms
    DELETE FROM "symbols" AS s0 WHERE (((s0."symbol" = ?) AND (s0."platform" = ?)) AND (s0."event_type" = ?)) ["btc", "mercado_bitcoin", "trades"]
    {:ok, {"trades", "btc"}}

    18:06:38.383 [warning] @MercadoBitcoin - No worker found for trades btc
  ```
  """
  def stop({:mercado_bitcoin, event_type, symbol}) do
    Logger.info("@MercadoBitcoin - Stopping link for trades for #{symbol}")

    event_type = Atom.to_string(event_type)

    Symbols.remove(%{
      symbol: symbol,
      platform: "mercado_bitcoin",
      event_type: event_type
    })

    MercadoBitcoin.DynamicSupervisor.stop({event_type, symbol})

    {:ok, {event_type, symbol}}
  end

  @doc """
  This function stop a especific platform symbol events and delete of the database.

  ## Examples
  ```elixir
    iex(2)> Trader.ticker({:binance, "btc"})

    18:06:12.796 [info] @Binance - Starting link for ticker for btc

    18:06:12.880 [debug] QUERY OK db=0.4ms idle=1638.6ms
    INSERT INTO "symbols" ("event_type","platform","symbol","inserted_at","updated_at","id") VALUES (?,?,?,?,?,?) ON CONFLICT ("symbol","platform","event_type") DO UPDATE SET "id" = EXCLUDED."id","symbol" = EXCLUDED."symbol","platform" = EXCLUDED."platform","event_type" = EXCLUDED."event_type","inserted_at" = EXCLUDED."inserted_at","updated_at" = EXCLUDED."updated_at" ["ticker", "binance", "btc", "2022-06-16T21:06:12", "2022-06-16T21:06:12", "32c0e457-d0b1-40bc-aef7-4b561256792a"]
    {:ok, #PID<0.354.0>}

    iex(3)> Trader.stop({:binance, :trades, "btc"})

    18:06:36.634 [info] @Binance - Stopping link for trades for btc

    18:06:36.640 [debug] QUERY OK source="symbols" db=0.4ms queue=0.1ms idle=1394.4ms
    DELETE FROM "symbols" AS s0 WHERE (((s0."symbol" = ?) AND (s0."platform" = ?)) AND (s0."event_type" = ?)) ["btc", "binance", "trades"]

    18:06:36.640 [warning] @Binance - No worker found for trades btc
    {:ok, {"trades", "btc"}}
    iex(4)> Trader.stop({:binance, :trades, "btc"})

    18:06:38.381 [info] @Binance - Stopping link for trades for btc

    18:06:38.383 [debug] QUERY OK source="symbols" db=0.7ms queue=0.1ms idle=1137.2ms
    DELETE FROM "symbols" AS s0 WHERE (((s0."symbol" = ?) AND (s0."platform" = ?)) AND (s0."event_type" = ?)) ["btc", "binance", "trades"]
    {:ok, {"trades", "btc"}}

    18:06:38.383 [warning] @Binance - No worker found for trades btc
  ```
  """
  def stop({:binance, event_type, symbol}) do
    Logger.info("@Binance - Stopping link for trades for #{symbol}")

    event_type = Atom.to_string(event_type)

    Symbols.remove(%{
      symbol: symbol,
      platform: "binance",
      event_type: event_type
    })

    Binance.DynamicSupervisor.stop({event_type, symbol})

    {:ok, {event_type, symbol}}
  end
end
