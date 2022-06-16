defmodule Trader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, [keys: :unique, name: :binance_workers]},
      {Registry, [keys: :unique, name: :mercado_bitcoin_workers]},
      Trader.Repo,
      {Trader.Binance.DynamicSupervisor, []},
      {Trader.MercadoBitcoin.DynamicSupervisor, []},
      {Task, fn -> Trader.init() end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
