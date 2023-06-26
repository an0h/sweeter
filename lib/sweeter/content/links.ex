defmodule Sweeter.Content.Links do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :type, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(links, attrs) do
    links
    |> cast(attrs, [:url, :type])
    |> validate_required([:url, :type])
  end
end
