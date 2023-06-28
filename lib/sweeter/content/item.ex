defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo
  alias Sweeter.Content.Item
  alias Sweeter.Content.Image
  alias Sweeter.Content.PublerSubser

  schema "items" do
    field :body, :string
    field :deleted, :boolean, default: false
    field :format, :string
    field :source, :string
    field :title, :string
    field :imagealt, :string
    has_many :images, Sweeter.Content.Image
    has_many :links, Sweeter.Content.Links
    belongs_to :user, Sweeter.People.User

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:body, :title, :deleted, :format, :source, :user_id, :imagealt])
    |> validate_required([:title])
  end

  def create_item(attrs \\ %{}) do
    {:ok, item} = %Item{}
      |> Item.changeset(attrs)
      |> Repo.insert()
    if attrs["ipfscids"] != nil do
      Image.create_item_image(item.id, attrs["ipfscids"], attrs["imagealt"])
    end
    {:ok, item}
  end

  def get_all do
    Repo.all(
      from i in "items",
        where: i.deleted != true,
        select: [i.id, i.body, i.title, i.deleted]
    )
    |> item_list_struct_converter
  end

  def subscription_feed(subser_id) do
    publers = PublerSubser.publer_id_list(subser_id)
    Repo.all(
      from i in "items",
        where: i.user_id in ^publers,
        select: [i.id, i.body, i.title, i.deleted]
    )
    |> item_list_struct_converter
  end

  defp item_list_struct_converter(item_list) do
    Enum.map(
      item_list,
      fn item ->
        [:id, :body, :title]
        |> Enum.zip(item)
        |> Map.new()
        |> Map.merge(%Item{}, fn _k, i, _empty -> i end)
      end
    )
  end
end
