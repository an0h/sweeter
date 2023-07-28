defmodule Sweeter.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sweeter.Content.Item

  schema "tags" do
    field :label, :string

    # many_to_many :items, Item, join_through: "item_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:label])
    # |> cast_assoc(:items)
    |> validate_required([:label])
  end
end
