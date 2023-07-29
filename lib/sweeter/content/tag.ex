defmodule Sweeter.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Tag
  alias Sweeter.Content.TagItem

  schema "tags" do
    field :label, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:label, :slug])
    |> validate_required([:label])
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def get_all() do
    Repo.all(Tag)
  end

  def get_tag_ids_by_slug(slugs) do
    s = Enum.map(String.split(slugs, ","), &String.trim/1)
    from(
      t in Tag,
      where: t.slug in ^s,
      select: t.id)
    |> Repo.all()
  end

  def get_tag_labels_for_item(item_id) do
    Repo.all(
      from ti in "tag_items",
      join: t in "tags",
      on: ti.tag_id == t.id,
      where: ti.item_id == ^item_id,
      select: t.label
    )
  end

  def get_tag_slugs_for_item(item_id) do
    Repo.all(
      from ti in "tag_items",
      join: t in "tags",
      on: ti.tag_id == t.id,
      where: ti.item_id == ^item_id,
      select: t.slug
    )
  end

  def tag_item(item_id, tags) do
    tags
    |> parse_tags
    |> iterate_tags(item_id)
  end

  def parse_tags(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  defp iterate_tags(list, item_id) do
    Enum.each(list, &save_tag(&1, item_id))
  end

  defp save_tag(tag_id, item_id) do
    save = %TagItem{}
    |> TagItem.changeset(%{item_id: item_id, tag_id: tag_id})
    |> Repo.insert()
  end
end
