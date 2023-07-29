defmodule Sweeter.Repo.Migrations.CreateItemLOads do
  use Ecto.Migration

  def change do
    create table(:load_counts) do
      add :item_id, :integer
      add :user_id, :integer

      timestamps()
    end
  end
end
