defmodule Sweeter.Content.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sweeter.Repo
  alias Sweeter.Content.Image

  schema "images" do
    field :alt, :string
    field :ipfscid, :string
    belongs_to :item, Sweeter.Content.Item

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:alt, :ipfscid, :item_id])
    |> validate_required([:ipfscid])
  end

  def create_item_image(item_id, ipfscid, alt) do
    %Image{}
    |> Image.changeset(%{ipfscid: ipfscid, item_id: item_id, alt: alt})
    |> Repo.insert()
  end
end
