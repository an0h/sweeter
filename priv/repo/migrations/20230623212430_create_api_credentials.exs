defmodule Sweeter.Repo.Migrations.CreateApiCredentials do
  use Ecto.Migration

  def change do
    create table(:api_credentials) do
      add :key, :string

      timestamps()
    end

  end
end
