defmodule Sweeter.People.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :address, :string
    field :age, :integer
    field :email, :string
    field :handle, :string
    field :name, :string
    field :password, :string
    field :reset_token, :string
    has_many :items, Sweeter.Content.Item

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:age, :name, :email, :password, :handle, :address, :reset_token])
    |> validate_required([:age, :name, :email, :password, :handle, :address, :reset_token])
  end
end
