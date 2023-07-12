defmodule Sweeter.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :alt, :string
      add :ipfscid, :string
      add :item_id, :integer

      timestamps()
    end
  end
end
