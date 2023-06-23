defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :body, :string
    field :deleted, :boolean, default: false
    field :format, :string
    field :source, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:body, :title, :deleted, :format, :source])
    |> validate_required([:body, :title, :deleted, :format, :source])
  end
end
