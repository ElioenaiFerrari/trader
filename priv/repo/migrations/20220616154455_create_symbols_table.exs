defmodule Trader.Repo.Migrations.CreateSymbolsTable do
  use Ecto.Migration

  def change do
    create table(:symbols, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :platform, :string
      add :symbol, :string
      add :event_type, :string

      timestamps()
    end

    create unique_index(:symbols, [:platform, :symbol, :event_type])
  end
end
