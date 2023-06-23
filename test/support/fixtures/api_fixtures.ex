defmodule Sweeter.APIFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sweeter.API` context.
  """

  @doc """
  Generate a feed.
  """
  def feed_fixture(attrs \\ %{}) do
    {:ok, feed} =
      attrs
      |> Enum.into(%{
        search: "some search"
      })
      |> Sweeter.API.create_feed()

    feed
  end
end
