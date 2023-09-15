defmodule Sweeter.Repo.Migrations.AddProfileCssIpfscid do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :css_ipfscid, :string
    end
  end
end
