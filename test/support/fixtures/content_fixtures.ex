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
        source: "some source",
        title: "some title"
      })
      |> Sweeter.Content.create_item()

    item
  end

  @doc """
  Generate a moderation.
  """
  def moderation_fixture(attrs \\ %{}) do
    {:ok, moderation} =
      attrs
      |> Enum.into(%{
        category: "some category",
        reason: "some reason",
        requestor_id: 42
      })
      |> Sweeter.Content.create_moderation()

    moderation
  end
end
