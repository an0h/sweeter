defmodule Sweeter.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions) do
      add :emoji, :string
      add :description, :string
      add :alt_text, :text
      add :item_id, references(:items)

      timestamps()
    end
  end
end
