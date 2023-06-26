defmodule Sweeter.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :type, :string
      add :item_id, references(:items)

      timestamps()
    end
  end
end
