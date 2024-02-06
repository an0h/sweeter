defmodule Sweeter.Repo.Migrations.UniqueHeadlineField do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE items ADD CONSTRAINT items_headline_unique UNIQUE (headline)"
  end

  def down do
    execute "ALTER TABLE items DROP CONSTRAINT items_headline_unique"
  end
end
