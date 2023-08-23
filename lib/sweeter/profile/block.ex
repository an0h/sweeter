defmodule Sweeter.Profile.Block do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Profile.Block

  schema "blocks" do
    field :blocked_id, :integer
    field :blocker_id, :integer

    timestamps()
  end

  @doc false
  def changeset(block, attrs) do
    block
    |> cast(attrs, [:blocked_id, :blocker_id])
    |> validate_required([:blocked_id, :blocker_id])
  end

  def get_blocks_for_user(blocker_id) do
    query = from(b in Block, where: b.blocker_id == ^blocker_id)
    Repo.all(query)
  end

  def create_block(blocked_id, blocker_id) do
    %Block{}
    |> Block.changeset(%{blocked_id: blocked_id, blocker_id: blocker_id})
    |> Repo.insert()
  end

  def unblock(blocked_id, blocker_id) do
    query = from(b in Block, where: b.blocked_id == ^blocked_id and b.blocker_id == ^blocker_id)
    Repo.delete_all(query)
  end

  def is_blocked(blocked_id, blocker_id) do
    count = count_block(blocked_id, blocker_id)
    if count >= 1 do
      true
    else
      false
    end
  end

  defp count_block(blocked_id, blocker_id) do
    from(b in Block, where: b.blocked_id == ^blocked_id and b.blocker_id == ^blocker_id)
    |> Repo.aggregate(:count, :id)
  end
end
