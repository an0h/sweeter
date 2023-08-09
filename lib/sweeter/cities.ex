defmodule Sweeter.Cities do
  @moduledoc """
  The Cities context.
  """

  import Ecto.Query, warn: false
  alias Sweeter.Repo

  alias Sweeter.Cities.Street

  @doc """
  Returns the list of streets.

  ## Examples

      iex> list_streets()
      [%Street{}, ...]

  """
  def list_streets do
    Repo.all(Street)
  end

  @doc """
  Gets a single street.

  Raises `Ecto.NoResultsError` if the Street does not exist.

  ## Examples

      iex> get_street!(123)
      %Street{}

      iex> get_street!(456)
      ** (Ecto.NoResultsError)

  """
  def get_street!(id), do: Repo.get!(Street, id)

  @doc """
  Creates a street.

  ## Examples

      iex> create_street(%{field: value})
      {:ok, %Street{}}

      iex> create_street(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_street(attrs \\ %{}) do
    %Street{}
    |> Street.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a street.

  ## Examples

      iex> update_street(street, %{field: new_value})
      {:ok, %Street{}}

      iex> update_street(street, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_street(%Street{} = street, attrs) do
    street
    |> Street.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a street.

  ## Examples

      iex> delete_street(street)
      {:ok, %Street{}}

      iex> delete_street(street)
      {:error, %Ecto.Changeset{}}

  """
  def delete_street(%Street{} = street) do
    Repo.delete(street)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking street changes.

  ## Examples

      iex> change_street(street)
      %Ecto.Changeset{data: %Street{}}

  """
  def change_street(%Street{} = street, attrs \\ %{}) do
    Street.changeset(street, attrs)
  end
end
