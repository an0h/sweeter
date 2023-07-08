defmodule Sweeter.Repo.Migrations.ReactionCanHaveUser do
  use Ecto.Migration

  def change do
    alter table(:reactions) do
      add :user_id, references(:users)
    end
  end
end
