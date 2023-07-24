defmodule Sweeter.Repo.Migrations.CreateModerations do
  use Ecto.Migration

  def change do
    create table(:moderations) do
      add :requestor_id, :bigint
      add :item_id, references(:items)
      add :reason, :text
      add :category, :string

      timestamps()
    end
  end
end
