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

  def create_block(blocked_id, blocker_id) do
    %Block{}
    |> Block.changeset(%{blocked_id: blocked_id, blocker_id: blocker_id})
    |> Repo.insert()
  end
end
