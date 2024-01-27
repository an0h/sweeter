defmodule Sweeter.Repo.Migrations.CreateCensorRecords do
  use Ecto.Migration

  def change do
    create table(:censor_records) do
      add :comment, :string
      add :submitted_by, :integer
      add :target_user_id, :integer

      timestamps()
    end
  end
end
