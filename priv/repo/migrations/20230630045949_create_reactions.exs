defmodule Sweeter.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions) do
      add :emoji, :string

      timestamps()
    end
  end
end
