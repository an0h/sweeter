defmodule SweeterWeb.FeedController do
  use SweeterWeb, :controller
  alias Swoosh.ApiClient.Hackney
  alias Sweeter.API
  alias Sweeter.API.Feed
  alias Sweeter.Content.Item

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

  def api_item_create(conn, attrs) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    ipfscid = upload_image(body)
    new = Map.merge(attrs,
      %{"body" => "", "imagealt" => "", "format" => "", "source" => "api", "ipfscids" => ipfscid},
      fn _k, v1, v2 ->
        v1
      end)
    case Item.create_item(new) do
      {:ok, item} ->
        render(conn, "item.json", item: item)
      {:error, %Ecto.Changeset{} = changeset} ->
        send_resp(conn, 404, "Item not created")
    end
  end

  def api_item_list(conn, _) do
    items = Item.get_all()
    IO.inspect items
    render(conn, "items.json", items: items)
  end

  def upload_image(image) do
    if image == "" do
      nil
    else
      url = "https://sweetipfs.herokuapp.com/upload"
      headers = [{"Content-Type", "multipart/form-data"}]
      {:ok, response} = HTTPoison.post(url, image, headers)
      response.body
    end
  end
end
