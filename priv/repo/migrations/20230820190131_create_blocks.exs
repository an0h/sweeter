defmodule Sweeter.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :blocked_id, :integer
      add :blocker_id, :integer

      timestamps()
    end
  end
end
