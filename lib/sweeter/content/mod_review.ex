defmodule Sweeter.Content.ModReview do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.ModReview

  schema "modreviews" do
    field :logentry, :string
    field :moderator_id, :integer
    field :note, :string
    has_many :moderations, Sweeter.Content.Moderation
    belongs_to :item, Sweeter.Content.Item

    timestamps()
  end

  @doc false
  def changeset(mod_review, attrs) do
    mod_review
    |> cast(attrs, [:item_id, :moderator_id, :note, :logentry])
    |> validate_required([:item_id, :moderator_id, :note, :logentry])
  end

  def create_review(attrs \\ %{}) do
    %ModReview{}
    |> ModReview.changeset(attrs)
    |> Repo.insert()
  end
end
