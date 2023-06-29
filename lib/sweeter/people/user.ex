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
    field :is_admin, :boolean
    has_many :items, Sweeter.Content.Item

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:age, :name, :email, :password, :handle, :address, :is_admin, :reset_token])
    |> validate_required([:age, :name, :email, :password, :handle])
    |> validate_password()
    |> put_password_hash()
    |> unique_constraint(:handle)
  end

  defp validate_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    if String.match?(password, ~r/^(?=.*[!@#$%^&*-])(?=.*[0-9])(?=.*[A-Z]).{8,60}$/) do
      changeset
    else
      add_error(changeset, :name, "Password must be longer than 8 characters and it requires an upper case letter, a number, and a symbol.")
    end
  end

  defp validate_password(%Ecto.Changeset{} = changeset) do
    changeset
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
