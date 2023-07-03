defmodule Sweeter.Repo.Migrations.UserHasCreds do
  use Ecto.Migration

  def change do
    alter table(:api_credentials) do
      add :user_id, references(:users)
    end
  end
end
