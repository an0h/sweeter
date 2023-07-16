defmodule Sweeter.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :body, :text
      add :deleted, :boolean, default: false, null: false
      add :source, :string
      add :title, :string
      add :search_suppressed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
