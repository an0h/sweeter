defmodule Sweeter.Content.Search do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Tag

  schema "searches" do
    field :tag_slug_list, :string

    timestamps()
  end

  def restricted_tags() do
    [["Anonymous","anonymous",nil],
    ["Controversial","controversial",nil],
    ["Crass","crass",nil],
    ["Sexually Explicit","sexually_explicit",nil],
    ["Violent","violent",nil]]
    |> Enum.map(&Tag.cast_tag/1)
  end

  def restricted_tag_ids() do
    %{
      1 => "anonymous",
      2 => "controversial",
      3 => "crass",
      4 => "sexually_explicit",
      5 => "violent"
    }
  end

  @doc false
  def changeset(search, attrs) do
    search
    |> cast(attrs, [:tag_slug_list])
    |> validate_required([:tag_slug_list])
  end

  def get_suggested_searches() do
    Tag.find_tags_to_search()
  end

  def get_items_by_restricted_tag(tag_id) do
    Repo.all(
      from i in "items",
      join: rti in "restricted_tag_items",
      on: rti.item_id == i.id,
      where: rti.restricted_tag_id == ^tag_id,
      where: i.deleted == false,
      where: i.search_suppressed == false,
      order_by: [desc: i.inserted_at],
      select: [i.id, i.inserted_at, i.body, i.headline, i.deleted, i.search_suppressed],
      limit: 300
    )
    |> item_list_converter
    |> Repo.preload(:images)
    |> Repo.preload(:reactions)
  end

  def get_items_by_tag(tag_id) do
    Repo.all(
      from i in "items",
      join: ti in "tag_items",
      on: ti.item_id == i.id,
      where: ti.tag_id == ^tag_id,
      where: i.deleted == false,
      where: i.search_suppressed == false,
      order_by: [desc: i.inserted_at],
      select: [i.id, i.inserted_at, i.body, i.headline, i.deleted, i.search_suppressed],
      limit: 300
    )
    |> item_list_converter
    |> Repo.preload(:images)
    |> Repo.preload(:reactions)
  end

  def get_all_query_matches(query) do
    Repo.all(
      from i in "items",
      or_where: ilike(i.body, ^query),
      or_where: ilike(i.headline, ^query),
      where: i.deleted == false,
      where: i.search_suppressed == false,
      order_by: [desc: i.inserted_at],
      select: [i.id, i.inserted_at, i.body, i.headline, i.deleted, i.search_suppressed],
      limit: 300
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
