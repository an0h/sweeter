defmodule Sweeter.Content.Reactions do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo
  alias Sweeter.Content.Emojicount
  alias Sweeter.Content.Reactions

  schema "reactions" do
    field :emoji, :string
    belongs_to :item, Sweeter.People.Item

    timestamps()
  end

  @doc false
  def changeset(reactions, attrs) do
    reactions
    |> cast(attrs, [:emoji, :item_id])
    |> validate_required([:emoji, :item_id])
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

  def get_reactions_for_item(item_id) do
    Repo.all(
      from r in "reactions",
        where: r.item_id == ^item_id,
        select: [r.emoji]
    )
    |> reaction_by_item_list_count
  end

  def reaction_by_item_list_count(reaction_list) do
    List.flatten(reaction_list)
    |> Enum.reduce(%{}, fn emoji, acc -> Map.update(acc, emoji, 1, &(&1 + 1)) end)
    |> Enum.map(&cast_emojicounts/1)
    |> Enum.sort_by(fn e -> e.count end, :desc)
  end

  defp cast_emojicounts(e) do
    {emoji, count} = e
    %Emojicount{emoji: emoji, count: count}
  end

end
