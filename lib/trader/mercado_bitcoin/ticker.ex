defmodule Trader.MercadoBitcoin.Ticker do
  defstruct [
    :symbol,
    :date,
    :last_price,
    :high_price,
    :low_price,
    :volume,
    :buy,
    :sell
  ]
end
