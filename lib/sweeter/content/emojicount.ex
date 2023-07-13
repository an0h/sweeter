defmodule Sweeter.Content.Emojicount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emojicounts" do
    field :count, :integer
    field :emoji, :string

    timestamps()
  end

  @doc false
  def changeset(emojicount, attrs) do
    emojicount
    |> cast(attrs, [:count, :emoji])
    |> validate_required([:count, :emoji])
  end
end
