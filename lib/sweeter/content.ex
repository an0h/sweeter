defmodule Sweeter.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Sweeter.Repo

  alias Sweeter.Content.Item
  alias Sweeter.Content.Tag
  alias Sweeter.Content.RestrictedTag

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    item
    |> Item.changeset(%{deleted: true})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  alias Sweeter.Content.Moderation

  @doc """
  Returns the list of moderations.

  ## Examples

      iex> list_moderations()
      [%Moderation{}, ...]

  """
  def list_moderations do
    Repo.all(Moderation)
  end

  @doc """
  Gets a single moderation.

  Raises `Ecto.NoResultsError` if the Moderation does not exist.

  ## Examples

      iex> get_moderation!(123)
      %Moderation{}

      iex> get_moderation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_moderation!(id), do: Repo.get!(Moderation, id)

  @doc """
  Creates a moderation.

  ## Examples

      iex> create_moderation(%{field: value})
      {:ok, %Moderation{}}

      iex> create_moderation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_moderation(attrs \\ %{}) do
    %Moderation{}
    |> Moderation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a moderation.

  ## Examples

      iex> update_moderation(moderation, %{field: new_value})
      {:ok, %Moderation{}}

      iex> update_moderation(moderation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_moderation(%Moderation{} = moderation, attrs) do
    moderation
    |> Moderation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a moderation.

  ## Examples

      iex> delete_moderation(moderation)
      {:ok, %Moderation{}}

      iex> delete_moderation(moderation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_moderation(%Moderation{} = moderation) do
    Repo.delete(moderation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking moderation changes.

  ## Examples

      iex> change_moderation(moderation)
      %Ecto.Changeset{data: %Moderation{}}

  """
  def change_moderation(%Moderation{} = moderation, attrs \\ %{}) do
    Moderation.changeset(moderation, attrs)
  end

  alias Sweeter.Content.Search

  @doc """
  Returns the list of searches.

  ## Examples

      iex> list_searches()
      [%Search{}, ...]

  """
  def list_searches do
    Repo.all(Search)
  end

  @doc """
  Gets a single search.

  Raises `Ecto.NoResultsError` if the Search does not exist.

  ## Examples

      iex> get_search!(123)
      %Search{}

      iex> get_search!(456)
      ** (Ecto.NoResultsError)

  """
  def get_search!(id), do: Repo.get!(Search, id)

  @doc """
  Creates a search.

  ## Examples

      iex> create_search(%{field: value})
      {:ok, %Search{}}

      iex> create_search(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_search(attrs \\ %{}) do
    %Search{}
    |> Search.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a search.

  ## Examples

      iex> update_search(search, %{field: new_value})
      {:ok, %Search{}}

      iex> update_search(search, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_search(%Search{} = search, attrs) do
    search
    |> Search.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a search.

  ## Examples

      iex> delete_search(search)
      {:ok, %Search{}}

      iex> delete_search(search)
      {:error, %Ecto.Changeset{}}

  """
  def delete_search(%Search{} = search) do
    Repo.delete(search)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking search changes.

  ## Examples

      iex> change_search(search)
      %Ecto.Changeset{data: %Search{}}

  """
  def change_search(%Search{} = search, attrs \\ %{}) do
    Search.changeset(search, attrs)
  end
end
