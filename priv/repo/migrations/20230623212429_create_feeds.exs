defmodule Sweeter.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :search, :string

      timestamps()
    end
  end
end
