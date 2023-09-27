defmodule Sweeter.Repo.Migrations.AddProfileType do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_type, :string
    end
  end
end
