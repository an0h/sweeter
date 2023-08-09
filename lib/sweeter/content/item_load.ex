defmodule Sweeter.Content.LoadCounts do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.LoadCounts

  schema "load_counts" do
    field :item_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(item_load, attrs) do
    item_load
    |> cast(attrs, [:item_id, :user_id])
    |> validate_required([:item_id])
  end

  def fetch_item_load_count(item_id) do
    id = get_id_int(item_id)
    Repo.all(
      from i in "load_counts",
        where: i.item_id == ^id,
        select: count(i.id)
    )
    |> List.first()
  end

  defp get_id_int(id) do
    case id do
      id when is_integer(id) ->
        id

      str when is_binary(str) ->
        case String.to_integer(str) do
          :error -> 0
          int -> int
        end

      _ ->
        0
    end
  end

  def increment_item_load_count(item_id) do
    result = %LoadCounts{}
    |> LoadCounts.changeset(%{item_id: String.to_integer(item_id)})
    |> Repo.insert()
    nil
  end

  def increment_item_load_count(item_id, user_id) do
    %LoadCounts{}
    |> LoadCounts.changeset(%{item_id: String.to_integer(item_id), user_id: user_id})
    |> Repo.insert()
  end
end
