defmodule Sweeter.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :body, :text
      add :deleted, :boolean, default: false, null: false
      add :source, :string
      add :headline, :string
      add :search_suppressed, :boolean, default: false, null: false
      add :user_id, references(:users)

      timestamps()
    end
  end
end
