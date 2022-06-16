defmodule Trader.Binance.DynamicSupervisor do
  use DynamicSupervisor

  require Logger

  defp via_tuple({event_type, symbol}) do
    {:via, Registry, {:binance_workers, "#{symbol}@#{event_type}"}}
  end

  def start_link(_state) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def trades(symbol) do
    DynamicSupervisor.start_child(__MODULE__, {Trader.Binance, {"@trade", symbol}})
  end

  def ticker(symbol) do
    DynamicSupervisor.start_child(__MODULE__, {Trader.Binance, {"@miniTicker", symbol}})
  end

  def stop({event_type, symbol}) do
    case(Registry.lookup(:binance_workers, "#{symbol}@#{event_type}")) do
      [{pid, _}] -> DynamicSupervisor.terminate_child(via_tuple({event_type, symbol}), pid)
      _ -> Logger.warn("@Binance - No worker found for #{event_type} #{symbol}")
    end
  end
end
