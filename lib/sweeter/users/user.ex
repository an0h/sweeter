defmodule Sweeter.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema,
    password_hash_methods: {&Argon2.hash_pwd_salt/1,
                            &Argon2.verify_pass/2}
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  alias Sweeter.Repo
  alias Sweeter.Users.User

  schema "users" do
    pow_user_fields()

    field :address, :string
    field :age, :integer
    field :handle, :string
    field :name, :string
    field :is_admin, :boolean
    field :timeout_until, :utc_datetime
    field :profile_pic_cid, :string
    field :blurb, :string
    field :location, :string
    has_many :items, Sweeter.Content.Item

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def profile_changeset(user, attrs) do
    {age, _} = Integer.parse(attrs["age"])
    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_change(:age, age)
    |> Ecto.Changeset.put_change(:blurb, attrs["blurb"])
    |> Ecto.Changeset.put_change(:handle, attrs["handle"])
    |> Ecto.Changeset.put_change(:location, attrs["location"])
    |> Ecto.Changeset.put_change(:name, attrs["name"])
    |> Ecto.Changeset.put_change(:profile_pic_cid, attrs["profile_pic_cid"])
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_user_profile(%User{} = user, attrs \\ %{}) do
    User.profile_changeset(user, attrs)
    |> Repo.update()
  end

  def change_user_address(user, address) do
    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_change(:address, address)
  end

  def get_profile(id) do
    Repo.get!(User, id)
  end
end
