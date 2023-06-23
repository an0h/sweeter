defmodule SweeterWeb.FeedJSON do
  alias Sweeter.API.Feed

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

  defp data(%Feed{} = feed) do
    %{
      id: feed.id,
      search: feed.search
    }
  end
end
