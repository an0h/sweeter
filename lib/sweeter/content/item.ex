defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Image
  alias Sweeter.Content.PublerSubser
  alias Sweeter.Content.RestrictedTagItem

  schema "items" do
    field :body, :string
    field :deleted, :boolean, default: false
    field :source, :string
    field :headline, :string
    field :search_suppressed, :boolean, default: false
    belongs_to :user, Sweeter.Users.User
    has_many :reactions, Sweeter.Content.Reactions
    has_many :images, Sweeter.Content.Image
    has_many :moderations, Sweeter.Content.Moderation
    has_many :restricted_tags, Sweeter.Content.RestrictedTagItem

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:body, :deleted, :source, :headline, :search_suppressed, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:headline])
    |> unique_constraint(:headline)
  end

  def get_all do
    Repo.all(
      from i in "items",
        where: i.deleted != true,
        select: [i.id, i.body, i.headline, i.source]
    )
    |> item_list_struct_converter
  end

  defp item_list_struct_converter(item_list) do
    Enum.map(
      item_list,
      fn item ->
        [:id, :body, :headline, :source]
        |> Enum.zip(item)
        |> Map.new()
        |> Map.merge(%Item{}, fn _k, i, _empty -> i end)
      end
    )
  end

  def create_item(attrs \\ %{}) do
    {:ok, item} = %Item{}
      |> Item.changeset(attrs)
      |> Repo.insert()
    if attrs["ipfscids"] != nil do
      Image.create_item_image(item.id, attrs["ipfscids"], attrs["imagealt"])
    end
    restricted_tag_item(item.id, attrs["restricted_tag_ids"])
    {:ok, item}
  end

  def subscription_feed(subser_id) do
    publers = PublerSubser.publer_id_list(subser_id)
    Repo.all(
      from i in "items",
        where: i.user_id in ^publers,
        select: [i.id, i.body, i.headline, i.deleted]
    )
    |> item_list_struct_converter
  end

  def get_restricted_tags(item_id) do
    Repo.all(
      from rti in "restricted_tag_items",
      join: rt in "restricted_tags",
      on: rti.restricted_tag_id == rt.id,
      where: rti.item_id == ^item_id,
      select: [rt.label]
    )
  end

  def get_tags(item_id) do
    Repo.all(
      from t in "tags",
      join: ti in "tag_items",
      on: ti.item_id == ^item_id,
      where: t.id == ^item_id,
      select: [t.label]
    )
  end

  def tag_item(item_id, tags) do
    tags
    |> parse_tags
    |> iterate_restricted_tags(item_id)
  end

  def restricted_tag_item(item_id, tags) do
    tags
    |> parse_tags
    |> iterate_restricted_tags(item_id)
  end

  defp parse_tags(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  defp iterate_restricted_tags(list, item_id) do
    Enum.each(list, &save_restricted_tag(&1, item_id))
  end

  defp save_restricted_tag(tag_id, item_id) do
    save = %RestrictedTagItem{}
    |> RestrictedTagItem.changeset(%{item_id: item_id, restricted_tag_id: tag_id})
    |> Repo.insert()
  end

  defp iterate_tags(list, item_id) do
    Enum.each(list, &save_tag(&1, item_id))
  end

  defp save_tag(tag_id, item_id) do
    save = %RestrictedTagItem{}
    |> RestrictedTagItem.changeset(%{item_id: item_id, tag_id: tag_id})
    |> Repo.insert()
  end
end
