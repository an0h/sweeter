defmodule Sweeter.Content.Emojicount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emojicount" do
    field :count, :integer
    field :emoji, :string

    timestamps()
  end

  @doc false
  def changeset(emojicount, attrs) do
    emojicount
    |> cast(attrs, [:emoji, :count])
    |> validate_required([:emoji, :count])
  end
end
