defmodule Trader.Repo.Symbols do
  alias Trader.Repo
  alias Trader.Schemas.Symbol

  import Ecto.Query, only: [from: 2]

  def add(params) do
    %Symbol{}
    |> Symbol.changeset(params)
    |> Repo.insert!(
      on_conflict: :replace_all,
      conflict_target: [:symbol, :platform, :event_type]
    )
  end

  def remove(%{symbol: symbol, platform: platform, event_type: event_type}) do
    from(Symbol,
      where: [symbol: ^symbol, platform: ^platform, event_type: ^event_type]
    )
    |> Repo.delete_all()
  end

  def list do
    Repo.all(Symbol)
  end
end
