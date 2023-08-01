defmodule Sweeter.Repo.Migrations.CreateModreviews do
  use Ecto.Migration

  def change do
    create table(:modreviews) do
      add :moderator_id, references(:users)
      add :item_id, references(:items)
      add :note, :text
      add :logentry, :text

      timestamps()
    end
  end
end
