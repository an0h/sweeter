defmodule Sweeter.Repo.Migrations.CreateTagItems do
  use Ecto.Migration

  def change do
    create table(:tag_items) do
      add :item_id, :integer
      add :tag_id, :integer

      timestamps()
    end
  end
end
