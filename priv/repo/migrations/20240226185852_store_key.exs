defmodule Sweeter.Repo.Migrations.StoreKey do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :key, :string
    end
  end
end
