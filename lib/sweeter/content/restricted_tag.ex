defmodule Sweeter.Content.RestrictedTag do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Tag
  alias Sweeter.Content.RestrictedTag
  alias Sweeter.Content.RestrictedTagItem

  schema "restricted_tags" do
    field :label, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(restricted_tag, attrs) do
    restricted_tag
    |> cast(attrs, [:label, :slug])
    |> validate_required([:label])
  end

  def get_all() do
    Repo.all(RestrictedTag)
  end

  def create_restricted_tag(attrs \\ %{}) do
    %RestrictedTag{}
    |> RestrictedTag.changeset(attrs)
    |> Repo.insert()
  end

  def get_restricted_tag_slugs() do
    Repo.all(
      from rt in "restricted_tags",
      select: rt.slug
    )
  end

  def get_restricted_tag_ids_by_slug(slugs) do
    if slugs == nil do
      []
    else
      s = Enum.map(String.split(slugs, ","), &String.trim/1)
      from(
        rt in RestrictedTag,
        where: rt.slug in ^s,
        select: rt.id)
      |> Repo.all()
    end
  end

  def get_restricted_tag_labels_for_item(item_id) do
    Repo.all(
      from rti in "restricted_tag_items",
      join: rt in "restricted_tags",
      on: rti.restricted_tag_id == rt.id,
      where: rti.item_id == ^item_id,
      select: rt.label
    )
  end

  def get_restricted_tag_slugs_for_item(item_id) do
    Repo.all(
      from rti in "restricted_tag_items",
      join: rt in "restricted_tags",
      on: rti.restricted_tag_id == rt.id,
      where: rti.item_id == ^item_id,
      select: rt.slug
    )
  end

  def restricted_tag_item(item_id, tags) do
    tags
    |> Tag.parse_tags
    |> iterate_restricted_tags(item_id)
  end

  defp iterate_restricted_tags(list, item_id) do
    Enum.each(list, &save_restricted_tag(&1, item_id))
  end

  defp save_restricted_tag(tag_id, item_id) do
    %RestrictedTagItem{}
    |> RestrictedTagItem.changeset(%{item_id: item_id, restricted_tag_id: tag_id})
    |> Repo.insert()
  end
end
