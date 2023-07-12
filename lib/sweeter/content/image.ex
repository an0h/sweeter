defmodule Sweeter.Content.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :alt, :string
    field :ipfscid, :string
    field :item_id, :integer

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:alt, :ipfscid, :item_id])
    |> validate_required([:alt, :ipfscid, :item_id])
  end
end
