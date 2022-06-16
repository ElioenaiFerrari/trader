defmodule Trader.Schemas.Symbol do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "symbols" do
    field(:symbol, :string)
    field(:platform, :string)
    field(:event_type, :string)

    timestamps()
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, [:platform, :symbol, :event_type])
    |> validate_required([:platform, :symbol, :event_type])
    |> unique_constraint([:platform, :symbol, :event_type],
      message: "Symbol already exists for this platform and event type"
    )
    |> validate_inclusion(:event_type, ["trades", "ticker"])
  end
end
