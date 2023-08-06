defmodule Sweeter.Repo.Migrations.AddFeaturedItemField do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :featured, :boolean
    end
  end
end
