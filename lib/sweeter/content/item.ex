defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Image
  alias Sweeter.Content.ModReview
  alias Sweeter.Content.PublerSubser
  alias Sweeter.Content.RestrictedTag
  alias Sweeter.Content.Tag
  alias Sweeter.Users.User

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
    has_many :modreviews, Sweeter.Content.ModReview

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

  def mod_item_changeset(item, attrs) do
    item
    |> cast(attrs, [:deleted, :source, :search_suppressed])
  end

  def get_all do
    Repo.all(
      from i in "items",
        where: i.deleted != true and i.search_suppressed != true,
        select: [i.id, i.body, i.headline, i.source, i.search_suppressed]
    )
    |> item_list_struct_converter
  end

  defp item_list_struct_converter(item_list) do
    Enum.map(
      item_list,
      fn item ->
        [:id, :body, :headline, :source, :search_suppressed]
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
    if attrs["restricted_tag_ids"] != nil do
      RestrictedTag.restricted_tag_item(item.id, attrs["restricted_tag_ids"])
    end
    if attrs["tag_ids"] != nil do
      Tag.tag_item(item.id, attrs["tag_ids"])
    end
    {:ok, item}
  end

  def log_moderator_item_update(submitted, item, moderator_id) do
    user_handle = User.get_moderator_handle_from_id(moderator_id)
    ModReview.create_review(%{
      "item_id" => item.id,
      "logentry" => "The #{user_handle} moderated, submitting with TAGS #{submitted["tag_ids"]} REQUIRED_TAGS #{submitted["required_tag_ids"]}.  The source is #{submitted["source"]} and search_suppressed is #{submitted["search_suppressed"]}",
      "note" => submitted["body"],
      "moderator_id" => moderator_id})
  end

  def write_moderation(item, attrs) do
    # if attrs["restricted_tag_ids"] != nil do
    #   RestrictedTag.restricted_tag_item(item.id, attrs["restricted_tag_ids"])
    # end
    # if attrs["tag_ids"] != nil do
    #   Tag.tag_item(item.id, attrs["tag_ids"])
    # end
    item
    |> Item.mod_item_changeset(attrs)
    |> Repo.update()
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
end
