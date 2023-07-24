defmodule Sweeter.Content.Moderation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "moderations" do
    field :category, :string
    field :reason, :string
    field :requestor_id, :integer
    field :item_id, :integer

    timestamps()
  end

  @doc false
  def changeset(moderation, attrs) do
    moderation
    |> cast(attrs, [:requestor_id, :reason, :category, :item_id])
    |> validate_required([:requestor_id, :reason, :category, :item_id])
    |> foreign_key_constraint(:requestor_id, name: :moderations_requestor_id_fkey,
       message: "requestor"
     )
  end
end
