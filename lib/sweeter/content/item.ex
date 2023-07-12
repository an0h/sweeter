defmodule Sweeter.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item

  schema "items" do
    field :body, :string
    field :deleted, :boolean, default: false
    field :source, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:body, :deleted, :source, :title])
    |> validate_required([:body, :deleted, :source, :title])
  end

  def get_all do
    Repo.all(
      from i in "items",
        where: i.deleted != true,
        select: [i.id, i.body, i.title, i.source]
    )
    |> item_list_struct_converter
  end

  defp item_list_struct_converter(item_list) do
    Enum.map(
      item_list,
      fn item ->
        [:id, :body, :title, :source]
        |> Enum.zip(item)
        |> Map.new()
        |> Map.merge(%Item{}, fn _k, i, _empty -> i end)
      end
    )
  end
end
