defmodule Sweeter.Content.RestrictedTagItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sweeter.Content.Item
  alias Sweeter.Content.RestrictedTag

  schema "restricted_tag_items" do
    belongs_to(:item, Item)
    belongs_to(:restricted_tag, RestrictedTag)

    timestamps()
  end

  @doc false
  def changeset(restricted_tag_item, attrs) do
    restricted_tag_item
    |> cast(attrs, [:item_id, :restricted_tag_id])
    |> validate_required([:item_id, :restricted_tag_id])
  end
end
