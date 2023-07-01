defmodule Sweeter.Repo.Migrations.CreateEmojicount do
  use Ecto.Migration

  def change do
    create table(:emojicount) do
      add :emoji, :string
      add :count, :integer

      timestamps()
    end
  end
end
