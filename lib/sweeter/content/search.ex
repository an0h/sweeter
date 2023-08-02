defmodule Sweeter.Content.Search do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.RestrictedTag
  alias Sweeter.Content.Tag

  schema "searches" do
    field :tag_slug_list, :string

    timestamps()
  end

  def restricted_tag_slugs() do
    ["anonymous","crass","controversial","sexually_explicit","violent"]
  end

  @doc false
  def changeset(search, attrs) do
    search
    |> cast(attrs, [:tag_slug_list])
    |> validate_required([:tag_slug_list])
  end

  def get_suggested_searches() do
    Tag.get_all_slugs
  end
end
