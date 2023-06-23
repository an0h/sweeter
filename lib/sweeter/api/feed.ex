defmodule Sweeter.API.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :search, :string

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:search])
    |> validate_required([:search])
  end
end
