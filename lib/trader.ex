defmodule Trader do
  require Logger

  alias Trader.{Binance, MercadoBitcoin, Repo.Symbols}

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

  def stop({:binance, event_type, symbol}) do
    Logger.info("@MercadoBitcoin - Stopping link for trades for #{symbol}")

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
