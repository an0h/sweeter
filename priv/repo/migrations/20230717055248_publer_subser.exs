defmodule Sweeter.Repo.Migrations.CreatePublerSubser do
  use Ecto.Migration

  def change do
    create table(:publer_subser) do
      add :publer_id, references(:users)
      add :subser_id, references(:users)

      timestamps()
    end
  end
end
