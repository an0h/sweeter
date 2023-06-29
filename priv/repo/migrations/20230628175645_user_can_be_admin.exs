defmodule Sweeter.Repo.Migrations.UserCanBeAdmin do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean
    end
  end
end
