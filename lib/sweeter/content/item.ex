defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sweeter.Repo
  alias Sweeter.Content.Item
  alias Sweeter.Content.Image

  schema "items" do
    field :body, :string
    field :deleted, :boolean, default: false
    field :format, :string
    field :source, :string
    field :title, :string
    has_many :images, Sweeter.Content.Image

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:body, :title, :deleted, :format, :source])
    |> validate_required([:title])
  end

  def create_item(attrs \\ %{}) do
    {:ok, item} = %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    %Item{id: item_id} = item
    if attrs["ipfscids"] != nil do
      IO.inspect "in the ipfscids"
      Image.create_item_image(item_id, attrs["ipfscids"])
    end
    {:ok, item}
  end
end
