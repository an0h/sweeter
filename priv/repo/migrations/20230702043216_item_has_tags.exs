defmodule Sweeter.Repo.Migrations.ItemHasTags do
  use Ecto.Migration

  def change do
    # Primary key and timestamps are not required if
    # using many_to_many without schemas
    create table("tag_items", primary_key: false) do
      add :tag_id, references(:tags)
      add :item_id, references(:items)
      timestamps()
    end
  end
end
