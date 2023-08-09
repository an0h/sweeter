defmodule Sweeter.CitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sweeter.Cities` context.
  """

  @doc """
  Generate a street.
  """
  def street_fixture(attrs \\ %{}) do
    {:ok, street} =
      attrs
      |> Enum.into(%{
        search: "some search"
      })
      |> Sweeter.Cities.create_street()

    street
  end
end
