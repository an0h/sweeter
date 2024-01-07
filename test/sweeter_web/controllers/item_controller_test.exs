defmodule SweeterWeb.ItemControllerTest do
  use SweeterWeb.ConnCase

  import Sweeter.ContentFixtures
  alias Sweeter.Content.Item

  @create_attrs %{body: "some body", deleted: true, source: "some source", headline: "some title"}
  @update_attrs %{body: "some updated body", deleted: false, source: "some updated source", headline: "some updated title"}
  @invalid_attrs %{body: nil, deleted: nil, source: nil, headline: nil}

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, ~p"/items")
      assert html_response(conn, 200) =~ "Help build internetstate.city! "
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/items/new")
      assert html_response(conn, 200) =~ "Help build internetstate.city! Check out the Elixir repo:"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/items/#{id}"

      conn = get(conn, ~p"/items/#{id}")
      assert html_response(conn, 302) =~ "redirected"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/items", item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Help build internetstate.city! Check out the Elixir repo:"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get(conn, ~p"/items/#{item}/edit")
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put(conn, ~p"/items/#{item}", item: @update_attrs)
      assert redirected_to(conn) == ~p"/items"

      conn = get(conn, ~p"/items/#{item}")
      assert html_response(conn, 302) =~ "redirect"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, ~p"/items/#{item}")
      assert redirected_to(conn) == ~p"/items"
    end
  end

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end
end
