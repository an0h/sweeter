defmodule Sweeter.Repo.Migrations.AddParentId do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :parent_id, :integer
    end
  end
end
