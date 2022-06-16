defmodule Trader do
  require Logger

  alias Trader.{Binance, MercadoBitcoin}

  def trades(:binance, symbol) do
    Logger.info("@Binance - Starting link for trades for #{symbol}")

    symbol
    |> String.downcase()
    |> Binance.DynamicSupervisor.trades()
  end

  def ticker(:binance, symbol) do
    Logger.info("@Binance - Starting link for ticker for #{symbol}")

    symbol
    |> String.downcase()
    |> Binance.DynamicSupervisor.ticker()
  end

  def trades(:mercado_bitcoin, symbol) do
    Logger.info("@MercadoBitcoin - Starting link for trades for #{symbol}")

    symbol
    |> String.downcase()
    |> MercadoBitcoin.DynamicSupervisor.trades()
  end

  def ticker(:mercado_bitcoin, symbol) do
    Logger.info("@MercadoBitcoin - Starting link for ticker for #{symbol}")

    symbol
    |> String.downcase()
    |> MercadoBitcoin.DynamicSupervisor.ticker()
  end
end
