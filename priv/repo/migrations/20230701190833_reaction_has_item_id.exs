defmodule Sweeter.Repo.Migrations.ReactionHasItemId do
  use Ecto.Migration

  def change do
    alter table(:reactions) do
      add :item_id, references(:items)
    end
  end
end
