defmodule Sweeter.Content.RestrictedTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restricted_tags" do
    field :label, :string
    field :form_field_name, :string

    timestamps()
  end

  @doc false
  def changeset(restricted_tag, attrs) do
    restricted_tag
    |> cast(attrs, [:label, :form_field_name])
    |> validate_required([:label])
  end
end
