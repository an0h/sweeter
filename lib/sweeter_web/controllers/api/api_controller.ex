defmodule SweeterWeb.API.V1.APIController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Item
  alias Sweeter.Content.Tag
  alias Sweeter.Content.RestrictedTag
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

  def api_tag_slug_list(conn, _) do
    tags = Tag.get_all()
    render(conn, "slugs.json", tags: tags)
  end

  def api_restricted_tag_slug_list(conn, _) do
    tags = RestrictedTag.get_all()
    render(conn, "slugs.json", tags: tags)
  end

  def api_item_create(conn, attrs) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    ipfscid = upload_image(body)
    if attrs["media"] do
      associate_links(attrs["media"])
    end
    tag_ids = Tag.get_tag_ids_by_slug(attrs["tag_slugs"])
      |> Enum.join(",")
    restricted_tag_ids = RestrictedTag.get_restricted_tag_ids_by_slug(attrs["restricted_tag_slugs"])
      |> Enum.join(",")
    {:ok, {user_id, user_address}} = user_id_address(conn)
    new = Map.merge(attrs,
      %{"body" => "",
        "imagealt" => "",
        "format" => "",
        "source" => "api",
        "ipfscids" => ipfscid,
        "user_id" => user_id,
        "tag_ids" => tag_ids,
        "restricted_tag_ids" => restricted_tag_ids},
      fn k, v1, _v2 ->
        v1
      end)
    case Item.create_item(new) do
      {:ok, item} ->
        IO.inspect item
        IO.puts "what?"
        if user_address != nil do
          CreditDebit.increment_api(user_address)
        end
        render(conn, "item.json", item: item)
      {:error, %Ecto.Changeset{} = _changeset} ->
        IO.inspect _changeset
        IO.puts "in error"
        send_resp(conn, "error.json", "Item not created")
      e ->
        IO.inspect e
        IO.puts "in err"
        send_resp(conn, "error.json", "Item not created")
    end
  end

  defp user_id_address(conn) do
    case Pow.Plug.current_user(conn) do
      nil ->
        {:error}
      user ->
        {:ok, {user.id, user.address}}
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
