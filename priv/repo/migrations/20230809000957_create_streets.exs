defmodule Sweeter.Repo.Migrations.CreateStreets do
  use Ecto.Migration

  def change do
    create table(:streets) do
      add :search, :string

      timestamps()
    end
  end
end
