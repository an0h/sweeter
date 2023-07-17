defmodule Sweeter.Repo.Migrations.CreatePublerSubser do
  use Ecto.Migration

  def change do
    create table(:publer_subser) do
      add :publer_id, :integer
      add :subser_id, :integer

      timestamps()
    end
  end
end
