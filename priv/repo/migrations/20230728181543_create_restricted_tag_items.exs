defmodule Sweeter.Repo.Migrations.CreateRestrictedTagItems do
  use Ecto.Migration

  def change do
    create table(:restricted_tag_items) do
      add :item_id, :integer
      add :restricted_tag_id, :integer

      timestamps()
    end
  end
end
