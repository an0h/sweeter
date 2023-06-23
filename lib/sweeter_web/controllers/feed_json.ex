defmodule SweeterWeb.FeedJSON do
  alias Sweeter.API.Feed
  alias Sweeter.Content.Item

  @doc """
  Renders a list of feeds.
  """
  def index(%{feeds: feeds}) do
    %{data: for(feed <- feeds, do: data(feed))}
  end

  @doc """
  Renders a single feed.
  """
  def show(%{feed: feed}) do
    %{data: data(feed)}
  end

  @doc """
  Renders a single item.
  """
  def item(%{item: item}) do
    %{item: itemize(item)}
  end

  defp data(%Feed{} = feed) do
    %{
      id: feed.id,
      search: feed.search
    }
  end

  defp itemize(%Item{} = item) do
    %{
      title: item.title,
      body: item.body
    }
  end
end
