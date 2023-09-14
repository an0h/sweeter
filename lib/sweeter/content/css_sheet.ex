defmodule Sweeter.Content.CssSheet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Sweeter.Repo

  alias Sweeter.Content.CssSheet

  schema "css_sheets" do
    field :ipfscid, :string
    field :name, :string
    belongs_to :user, Sweeter.Users.User

    timestamps()
  end

  @doc false
  def changeset(css_sheet, attrs) do
    css_sheet
    |> cast(attrs, [:name, :ipfscid,:user_id])
    |> validate_required([:name, :ipfscid])
  end

  def create_style(attrs \\ %{}) do
    %CssSheet{}
    |> CssSheet.changeset(attrs)
    |> Repo.insert()
  end

end
