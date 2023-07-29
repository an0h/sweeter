defmodule Sweeter.Repo.Migrations.CreateRestrictedTags do
  use Ecto.Migration

  def change do
    create table(:restricted_tags) do
      add :label, :string
      add :slug, :string

      timestamps()
    end
  end
end
