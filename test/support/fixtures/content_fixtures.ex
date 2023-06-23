defmodule Sweeter.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sweeter.Content` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        body: "some body",
        deleted: true,
        format: "some format",
        source: "some source",
        title: "some title"
      })
      |> Sweeter.Content.create_item()

    item
  end
end
