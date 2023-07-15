defmodule Sweeter.Repo.Migrations.UserInTimeout do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :timeout_until, :utc_datetime
    end
  end
end
