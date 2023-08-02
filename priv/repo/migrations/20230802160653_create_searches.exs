defmodule Sweeter.Repo.Migrations.CreateSearches do
  use Ecto.Migration

  def change do
    create table(:searches) do
      add :tag_slug_list, :text

      timestamps()
    end
  end
end
