defmodule SweeterWeb.FeedController do
  use SweeterWeb, :controller

  alias Sweeter.API
  alias Sweeter.API.Feed

  action_fallback SweeterWeb.FallbackController

  def index(conn, _params) do
    feeds = API.list_feeds()
    render(conn, :index, feeds: feeds)
  end

  def create(conn, %{"feed" => feed_params}) do
    with {:ok, %Feed{} = feed} <- API.create_feed(feed_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/feeds/#{feed}")
      |> render(:show, feed: feed)
    end
  end

  def show(conn, %{"id" => id}) do
    feed = API.get_feed!(id)
    render(conn, :show, feed: feed)
  end

  def update(conn, %{"id" => id, "feed" => feed_params}) do
    feed = API.get_feed!(id)

    with {:ok, %Feed{} = feed} <- API.update_feed(feed, feed_params) do
      render(conn, :show, feed: feed)
    end
  end

  def delete(conn, %{"id" => id}) do
    feed = API.get_feed!(id)

    with {:ok, %Feed{}} <- API.delete_feed(feed) do
      send_resp(conn, :no_content, "")
    end
  end
end
