defmodule SweeterWeb.API.V1.APIController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Item
  alias Sweeter.CreditDebit

  action_fallback SweeterWeb.FallbackController

  def search(conn, %{}) do
    items = Content.list_items()
    conn
    |> render("items.json", items: items)
  end

  def api_item_list(conn, _) do
    items = Item.get_all()
    render(conn, "items.json", items: items)
  end

  def api_item_create(conn, attrs) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    ipfscid = upload_image(body)
    if attrs["media"] do
      associate_links(attrs["media"])
    end
    new = Map.merge(attrs,
      %{"body" => "", "imagealt" => "", "format" => "", "source" => "api", "ipfscids" => ipfscid},
      fn _k, v1, _v2 ->
        v1
      end)
    case Item.create_item(new) do
      {:ok, item} ->
        case Pow.Plug.current_user(conn) do
          nil ->
            IO.puts "no user credited for api item"
          user ->
            CreditDebit.increment_api(user.address)
        end
        render(conn, "item.json", item: item)
      {:error, %Ecto.Changeset{} = _changeset} ->
        send_resp(conn, "error.json", "Item not created")
    end
  end

  defp upload_image(image) do
    if image == "" do
      nil
    else
      url = "https://sweetipfs.herokuapp.com/upload"
      headers = [{"Content-Type", "multipart/form-data"}]
      {:ok, response} = HTTPoison.post(url, image, headers)
      response.body
    end
  end

  defp associate_links(urls) do
    IO.inspect urls
    # Enum.map(
    #   urls,
    #   fn link ->
    #     IO.inspect link
    #   end
    # )
  end
end