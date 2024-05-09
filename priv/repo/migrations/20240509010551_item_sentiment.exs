defmodule Sweeter.Repo.Migrations.ItemSentiment do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :sentiment, :string
    end
  end
end
