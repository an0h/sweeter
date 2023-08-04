defmodule Sweeter.Repo.Migrations.AddUserIdToTag do
  use Ecto.Migration

  def change do
    alter table(:tags) do
      add :submitted_by, references(:users)
    end
  end
end
