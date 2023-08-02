defmodule Sweeter.Content.Search do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
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

  def get_all_query_matches(query) do
    Repo.all(
      from i in "items",
      or_where: ilike(i.body, ^query),
      or_where: ilike(i.headline, ^query),
        # where: is_nil(i.deleted),
        # where: is_nil(i.search_suppressed),
      select: [i.id, i.inserted_at, i.body, i.headline, i.deleted, i.search_suppressed]
    )
    |> item_list_converter
  end


  def item_list_converter(item_list) do
    Enum.map(
      item_list,
      fn item ->
        [:id, :inserted_at, :body, :headline, :deleted, :search_suppressed]
        |> Enum.zip(item)
        |> Map.new()
        |> Map.merge(%Item{}, fn _k, i, _empty -> i end)
      end
    )
  end
end
