defmodule Sweeter.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :alt_text, :text
      add :ipfscid, :string
      add :item_id, references(:items)

      timestamps()
    end
  end
end
