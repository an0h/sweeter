defmodule Sweeter.Content.Reactions do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo
  alias Sweeter.Content.Reactions

  schema "reactions" do
    field :emoji, :string

    timestamps()
  end

  @doc false
  def changeset(reactions, attrs) do
    reactions
    |> cast(attrs, [:emoji])
    |> validate_required([:emoji])
  end

  def create_item_reaction(reaction, item_id) do
    r = Map.put(reaction, :item_id, item_id)

    %Reactions{}
    |> Reactions.changeset(r)
    |> Repo.insert()
  end

  def create_item_reaction(reaction, item_id, user_id) do
    r = Map.put(reaction, :item_id, item_id) |> Map.put(:user_id, user_id)

    %Reactions{}
    |> Reactions.changeset(r)
    |> Repo.insert()
  end
end
