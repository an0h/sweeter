defmodule Sweeter.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :age, :integer
      add :name, :string
      add :email, :string
      add :password, :string
      add :handle, :string
      add :address, :string
      add :reset_token, :string

      timestamps()
    end
  end
end
