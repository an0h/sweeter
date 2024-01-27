defmodule Sweeter.Censor.Records do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sweeter.Repo
  alias Sweeter.Censor.Records

  schema "censor_records" do
    field :comment, :string
    field :submitted_by, :integer
    field :target_user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(records, attrs) do
    records
    |> cast(attrs, [:comment, :submitted_by, :target_user_id])
    |> validate_required([:comment, :submitted_by, :target_user_id])
  end

  def make_record(comment, submitted_by, target_user_id) do
    %Records{}
    |> Records.changeset(%{comment: comment, submitted_by: submitted_by, target_user_id: target_user_id})
    |> Repo.insert()
  end

end
