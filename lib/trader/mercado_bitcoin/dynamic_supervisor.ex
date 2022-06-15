defmodule Trader.MercadoBitcoin.DynamicSupervisor do
  use DynamicSupervisor

  require Logger

  def start_link(_state) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def ticker(symbol) do
    Logger.info("Starting link for ticker for #{symbol}")

    DynamicSupervisor.start_child(__MODULE__, {Trader.MercadoBitcoin, {:ticker, symbol}})
  end

  def trades(symbol) do
    Logger.info("Starting link for trades for #{symbol}")

    DynamicSupervisor.start_child(__MODULE__, {Trader.MercadoBitcoin, {:trades, symbol}})
  end
end