defmodule Sweeter.Content.RestrictedTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restricted_tags" do
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(restricted_tag, attrs) do
    restricted_tag
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
