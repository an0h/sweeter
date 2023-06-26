defmodule Sweeter.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false
  alias Sweeter.Repo

  alias Sweeter.People.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_a_mnemonic() do
    url = "http://localhost:3333/"
    headers = []

    IO.puts "in this get a mnemonic"
    try do
      {status, response} =
        HTTPoison.get(
          url,
          '',
          headers
        )
        IO.inspect status
        IO.inspect response
    rescue
      e in HTTPoison.Error ->
        IO.inspect(e)
    end
  end

  def get_cosmos_by_address() do
    url = "http://0.0.0.0:1317/cosmos/auth/v1beta1/accounts/cosmos1vn7lpkxjkjvz26vntmn0h3l56us3hy40nau8ds"
    headers = [{"Content-type", "application/json"}, {"accept", "application/json"}]

    IO.puts "in this cosmos"
    try do
      {status, response} =
        HTTPoison.get(
          url,
          '',
          headers
        )
        IO.inspect status
        IO.inspect response
    rescue
      e in HTTPoison.Error ->
        IO.inspect(e)
    end
  end

  def add_spicy_token(value) do
    headers = [
      {"accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    body = %{
      "address" => "cosmos1vn7lpkxjkjvz26vntmn0h3l56us3hy40nau8ds",
      "coins" => [value]
    }

    response = HTTPoison.post!("http://0.0.0.0:4500/", Poison.encode!(body), headers)

    # Access the response status code, headers, and body
    status_code = response.status_code
    response_headers = response.headers
    response_body = Poison.decode!(response.body)

    IO.inspect(status_code)
    IO.inspect(response_headers)
    IO.inspect(response_body)
  end
end
