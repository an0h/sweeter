defmodule Sweeter.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions) do
      add :emoji, :string
      add :description, :string
      add :alt_text, :string
      add :item_id, :integer

      timestamps()
    end
  end
end
