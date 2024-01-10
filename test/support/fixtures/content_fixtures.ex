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
        headline: "some title"
      })
      |> Sweeter.Content.Item.create_item()

    item
  end

  @doc """
  Generate a moderation.
  """
  def moderation_fixture(attrs \\ %{}) do
    item = item_fixture()
    {:ok, moderation} =
      attrs
      |> Enum.into(%{
        category: "some category",
        reason: "some reason",
        requestor_id: 42,
        item_id: item.id
      })
      |> Sweeter.Content.create_moderation()

    moderation
  end

  @doc """
  Generate a search.
  """
  def search_fixture(attrs \\ %{}) do
    {:ok, search} =
      attrs
      |> Enum.into(%{
        tag_slug_list: "some tag_slug_list"
      })
      |> Sweeter.Content.create_search()

    search
  end
end
