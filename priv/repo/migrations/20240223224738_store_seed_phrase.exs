defmodule Sweeter.Repo.Migrations.StoreSeedPhrase do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :seed_phrase, :string
    end
  end
end
