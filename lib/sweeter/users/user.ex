defmodule Sweeter.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema,
    password_hash_methods: {&Argon2.hash_pwd_salt/1,
                            &Argon2.verify_pass/2}
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  import Ecto.Changeset

  alias Sweeter.Repo
  alias Sweeter.Users.User

  schema "users" do
    pow_user_fields()

    field :address, :string
    field :age, :integer
    field :handle, :string
    field :name, :string
    field :is_admin, :boolean
    field :is_moderator, :boolean
    field :timeout_until, :utc_datetime
    field :profile_pic_cid, :string
    field :blurb, :string
    field :location, :string
    field :css_ipfscid, :string
    field :profile_type, :string
    has_many :items, Sweeter.Content.Item

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> profile_changeset(attrs)
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [:age, :address, :blurb, :handle, :location, :name, :is_admin, :is_moderator, :profile_pic_cid, :timeout_until, :css_ipfscid, :profile_type])
    |> unique_constraint(:handle)
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

  def get_handle_profile(handle) do
    Repo.get_by!(User, handle: handle)
  end

  def get_handle_from_id(id) do
    case read_cache_handle(id) do
      {:aborted, {:no_exists, Handles}} ->
        case Repo.get(User, id) do
          nil ->
            "anon"
          user ->
            handle = get_handle_or_email(user)
            cache_handle(id, handle)
            handle
        end

      {:atomic, []} ->
        "anon"

      handle ->
        handle
    end
  end

  defp read_cache_handle(id) do
    data_to_read = fn ->
      :mnesia.read({Handles, id})
    end
    :mnesia.transaction(data_to_read)
  end

  defp cache_handle(id, handle) do
    data_to_write = fn ->
      :mnesia.write({Handles, id, handle})
    end
    :mnesia.transaction(data_to_write)
  end

  defp get_handle_or_email(user) do
    if user.handle == nil or user.handle == "" do
      user.email
    else
      user.handle
    end
  end

  def get_is_moderator(conn) do
    case Pow.Plug.current_user(conn) do
      nil ->
        false
      user ->
        IO.inspect user
        profile = User.get_profile(user.id)
        profile.is_admin || profile.is_moderator
    end
  end

  def get_moderator_id(conn) do
    case Pow.Plug.current_user(conn) do
      nil ->
        false
      user ->
        profile = User.get_profile(user.id)
        if profile.is_admin || profile.is_moderator do
          profile.id
        else
          false
        end
    end
  end
end
