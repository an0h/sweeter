defmodule Sweeter.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Tag
  alias Sweeter.Content.TagItem

  schema "tags" do
    field :label, :string
    field :slug, :string
    field :submitted_by, :integer

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:label, :slug, :submitted_by])
    |> validate_required([:label, :slug])
    |> foreign_key_constraint(:submitted_by, name: :tags_submitted_by_fkey,
       message: "submitted_by"
     )
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

  def get_all_submitted_by(user_id) do
    Repo.all(
      from t in "tags",
      where: t.submitted_by == ^user_id,
      select: [t.label, t.slug, t.submitted_by]
    ) |> Enum.map(&cast_tag/1)
  end

  def cast_tag(tag) do
    [label, slug, submitted_by] = tag
    %Tag{label: label, slug: slug, submitted_by: submitted_by}
  end

  def get_all_slugs() do
    Repo.all(
      from t in "tags",
      select: t.slug
    )
  end

  def find_tags_to_search() do
    Repo.all(Tag)
  end

  def get_tag_ids_by_slug(slugs) do
    if slugs == nil do
      []
    else
      s = Enum.map(String.split(slugs, ","), &String.trim/1)
      from(
        t in Tag,
        where: t.slug in ^s,
        select: t.id)
      |> Repo.all()
    end
  end

  def get_tag_id_by_slug(slug) do
    if slug == nil do
      []
    else
      from(
        t in Tag,
        where: t.slug == ^slug,
        select: t.id)
      |> Repo.one()
    end
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

  def popular_tags() do
    Repo.all(
      from ti in "tag_items",
      join: t in "tags",
      on: ti.tag_id == t.id,
      where: fragment("? > NOW() - INTERVAL '24 hours'", ti.inserted_at),
      group_by: t.id,
      select: %{count: count(ti.id), label: t.label}
    )
  end

  def parse_tags(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  def convert_to_slug(label) do
    label
    |> String.downcase()                      # Convert to lowercase
    |> String.replace(~r/[^a-zA-Z0-9\s]/, "") # Remove anything that isn't a letter or number
    |> String.replace(~r/\s+/, "_")           # Replace spaces with underscores
    |> String.trim("_")                       # Trim underscores from the beginning and end
  end

  defp iterate_tags(list, item_id) do
    Enum.each(list, &save_tag(&1, item_id))
  end

  defp save_tag(tag_id, item_id) do
    %TagItem{}
    |> TagItem.changeset(%{item_id: item_id, tag_id: tag_id})
    |> Repo.insert()
  end
end
