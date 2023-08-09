defmodule Sweeter.Cities.Street do
  use Ecto.Schema
  import Ecto.Changeset

  schema "streets" do
    field :search, :string

    timestamps()
  end

  @doc false
  def changeset(street, attrs) do
    street
    |> cast(attrs, [:search])
    |> validate_required([:search])
  end
end
