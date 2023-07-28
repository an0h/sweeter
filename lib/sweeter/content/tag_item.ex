defmodule Sweeter.Content.TagItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag_items" do
    field :item_id, :integer
    field :tag_id, :integer

    timestamps()
  end

  @doc false
  def changeset(tag_item, attrs) do
    tag_item
    |> cast(attrs, [:item_id, :tag_id])
    |> validate_required([:item_id, :tag_id])
  end
end
