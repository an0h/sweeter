defmodule Sweeter.Profile.PublerSubser do
  # Because PubSub is already an Elixir concept
  # Publer and Subser
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Profile.PublerSubser


  schema "publer_subser" do
    field :publer_id, :integer
    field :subser_id, :integer

    timestamps()
  end

  @doc false
  def changeset(publer_subser, attrs) do
    publer_subser
    |> cast(attrs, [:publer_id, :subser_id])
    |> validate_required([:publer_id, :subser_id])
    |> unique_constraint(:publer_subser, name: :publer_subser_publer_id_subser_id_index)
  end

  def subscription_feed(subser_id) do
    publist = publer_id_list(subser_id)
    Repo.all(
      from i in "items",
        where: i.user_id in ^publist,
        order_by: [desc: :inserted_at],
        select: [i.id, i.body, i.headline, i.deleted]
    )
    |> Item.item_list_struct_converter
    |> Repo.preload(:images)
  end

  defp publer_id_list(subser_id) do
    Repo.all(
      from ps in "publer_subser",
        where: ps.subser_id == ^subser_id,
        select: ps.publer_id
    )
  end

  def subser(publer_id, subser_id) do
    %PublerSubser{}
    |> PublerSubser.changeset(%{publer_id: publer_id, subser_id: subser_id})
    |> Repo.insert()
  end

  def unsubser(publer_id, subser_id) do
    query = from(p in PublerSubser, where: p.publer_id == ^publer_id and p.subser_id == ^subser_id)
    Repo.delete_all(query)
  end

  def is_subscribed(publer_id, subser_id) do
    count = count_publer_subsers(publer_id, subser_id)
    if count >= 1 do
      true
    else
      false
    end
  end

  defp count_publer_subsers(publer_id, subser_id) do
    from(p in PublerSubser, where: p.publer_id == ^publer_id and p.subser_id == ^subser_id)
    |> Repo.aggregate(:count, :id)
  end
end
