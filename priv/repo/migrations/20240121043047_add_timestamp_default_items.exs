defmodule Sweeter.Repo.Migrations.AddTimestampDefaultItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      modify :inserted_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP")
      modify :updated_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP")
    end
  end
end
