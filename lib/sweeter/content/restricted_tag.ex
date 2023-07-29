defmodule Sweeter.Content.RestrictedTag do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.RestrictedTag

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

  def create_restricted_tag(attrs \\ %{}) do
    %RestrictedTag{}
    |> RestrictedTag.changeset(attrs)
    |> Repo.insert()
  end
end
