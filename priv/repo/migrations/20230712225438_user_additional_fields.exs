defmodule Sweeter.Repo.Migrations.UserAdditionalFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :address, :string
      add :age, :integer
      add :handle, :string
      add :name, :string
      add :is_admin, :boolean
      add :blurb, :string
      add :location, :string
      add :profile_pic_cid, :string
      add :timeout_until, :utc_datetime
    end
  end
end
