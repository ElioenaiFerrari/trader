defmodule Trader.Binance.Ticker do
  defstruct [
    :event_type,
    :event_time,
    :symbol,
    :open_price,
    :close_price,
    :high_price,
    :low_price,
    :base_volume,
    :quote_volume
  ]
end
