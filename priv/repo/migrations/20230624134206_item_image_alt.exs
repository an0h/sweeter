defmodule Sweeter.Repo.Migrations.ItemImageAlt do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :imagealt, :string
    end
  end
end
