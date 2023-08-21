defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Image
  alias Sweeter.Content.ModReview
  alias Sweeter.Content.RestrictedTag
  alias Sweeter.Content.Tag
  alias Sweeter.Users.User

  schema "items" do
    field :body, :string
    field :deleted, :boolean, default: false
    field :source, :string
    field :headline, :string
    field :search_suppressed, :boolean, default: false
    field :featured, :boolean, default: false
    field :parent_id, :integer
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
    |> cast(attrs, [:body, :deleted, :source, :headline, :search_suppressed, :user_id, :featured, :parent_id])
    |> cast_assoc(:user)
    |> validate_required([:headline])
    |> unique_constraint(:headline)
    |> validate_length(:headline, max: 255)
  end

  def mod_item_changeset(item, attrs) do
    item
    |> cast(attrs, [:deleted, :featured, :source, :search_suppressed])
  end

  def feature_changeset(item, attrs) do
    item
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_change(:featured, attrs["featured"])
  end

  def change_item_featured(%Item{} = item, attrs \\ %{}) do
    Item.feature_changeset(item, attrs)
    |> Repo.update()
  end

  def get_all do
    Repo.all(
      from i in "items",
        where: i.deleted != true and i.search_suppressed != true and i.parent_id == 0,
        order_by: [desc: :inserted_at],
        select: [i.id, i.body, i.headline, i.source, i.search_suppressed],
        limit: 300
    )
    |> item_list_struct_converter
  end

  def item_list_struct_converter(item_list) do
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

  def log_moderator_feature_change(item, moderator_id, feature_status) do
    user_handle = User.get_moderator_handle_from_id(moderator_id)
    ModReview.create_review(%{
      "item_id" => item.id,
      "logentry" => "#{user_handle} #{feature_status} this item.",
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

  def get_all_by_user(ui) do
    Repo.all(
      from i in "items",
        where: i.user_id == ^ui,
        order_by: [desc: :inserted_at],
        select: [i.id, i.body, i.headline, i.deleted],
        limit: 300
    )
    |> item_list_struct_converter
    |> Repo.preload(:images)
  end

  def get_replies(id) do
    Repo.all(
      from i in "items",
        where: i.parent_id == ^id,
        order_by: [desc: :inserted_at],
        select: [i.id, i.body, i.headline, i.deleted],
        limit: 300
    )
    |> item_list_struct_converter
    |> Repo.preload(:images)
  end

  def get_parent(item) do
    if item.parent_id == 0 do
      nil
    else
      Repo.get!(Item, item.parent_id)
    end
  end

  def get_featured_items() do
    Repo.all(
      from i in "items",
        where: i.featured == true,
        order_by: [desc: :inserted_at],
        select: [i.id, i.body, i.headline, i.deleted],
        limit: 300
    )
    |> item_list_struct_converter
  end
end
