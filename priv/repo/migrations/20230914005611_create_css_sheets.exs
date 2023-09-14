defmodule Sweeter.Repo.Migrations.CreateCssSheets do
  use Ecto.Migration

  def change do
    create table(:css_sheets) do
      add :name, :string
      add :ipfscid, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
