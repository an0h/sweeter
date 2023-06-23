defmodule Sweeter.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :body, :string
      add :title, :string
      add :deleted, :boolean, default: false, null: false
      add :format, :string
      add :source, :string

      timestamps()
    end
  end
end
