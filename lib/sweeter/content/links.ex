defmodule Sweeter.Content.Links do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :type, :string
    field :url, :string
    belongs_to :item, Sweeter.Content.Item

    timestamps()
  end

  @doc false
  def changeset(links, attrs) do
    links
    |> cast(attrs, [:url, :type, :item_id])
    |> validate_required([:url, :type])
  end
end
