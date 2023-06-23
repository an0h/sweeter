defmodule Sweeter.API.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sweeter.Repo
  alias Sweeter.API.Credential
  import Ecto.Query

  schema "api_credentials" do
    field :key, :string
    belongs_to :user, Sweeter.People.User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:key, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:key])
  end

  def create_credential(user_id) do
    IO.inspect user_id
    s = for _ <- 1..32, into: "", do: <<Enum.random('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')>>
    %Credential{}
    |> Credential.changeset(%{key: s, user_id: user_id})
    |> Repo.insert()
  end

  def check_credential([apikey] = _params) do
    count = Repo.all(
      from c in "api_credentials",
        where: c.key == ^apikey,
        select: count(c.id)
    )
    |> List.first()
    if count == 1 do
      true
    else
      false
    end
  end
end
