defmodule Sweeter.Repo.Migrations.CreateEmojicounts do
  use Ecto.Migration

  def change do
    create table(:emojicounts) do
      add :count, :integer
      add :emoji, :string

      timestamps()
    end
  end
end
