defmodule Sweeter.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Tag

  schema "tags" do
    field :label, :string
    field :form_field_name, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:label, :form_field_name])
    |> validate_required([:label])
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def get_all() do
    Repo.all(Tag)
  end
end
