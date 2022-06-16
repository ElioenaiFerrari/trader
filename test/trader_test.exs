defmodule TraderTest do
  use ExUnit.Case
  import Mock
  doctest Trader

  alias Trader.Repo.Symbols
  alias Trader.Schemas.Symbol

  describe "init" do
    test "when called, it should call Trader.trades" do
      with_mock(Symbols,
        list: fn ->
          [
            %Symbol{
              symbol: "btc",
              platform: "binance",
              event_type: "trades"
            }
          ]
        end
      )

      with_mock(Trader, trades: fn args -> [] end, ticker: fn args -> [] end)
      Trader.init()

      assert_called(Trader.trades({}))
    end
  end
end
