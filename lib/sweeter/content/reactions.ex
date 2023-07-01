defmodule Sweeter.Content.Reactions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reactions" do
    field :emoji, :string

    timestamps()
  end

  @doc false
  def changeset(reactions, attrs) do
    reactions
    |> cast(attrs, [:emoji])
    |> validate_required([:emoji])
  end
end
