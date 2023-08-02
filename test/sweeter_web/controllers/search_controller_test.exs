defmodule SweeterWeb.SearchControllerTest do
  use SweeterWeb.ConnCase

  import Sweeter.ContentFixtures

  @create_attrs %{tag_slug_list: "some tag_slug_list"}
  @update_attrs %{tag_slug_list: "some updated tag_slug_list"}
  @invalid_attrs %{tag_slug_list: nil}

  describe "index" do
    test "lists all searches", %{conn: conn} do
      conn = get(conn, ~p"/searches")
      assert html_response(conn, 200) =~ "Listing Searches"
    end
  end

  describe "new search" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/searches/new")
      assert html_response(conn, 200) =~ "New Search"
    end
  end

  describe "create search" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/searches", search: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/searches/#{id}"

      conn = get(conn, ~p"/searches/#{id}")
      assert html_response(conn, 200) =~ "Search #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/searches", search: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Search"
    end
  end

  describe "edit search" do
    setup [:create_search]

    test "renders form for editing chosen search", %{conn: conn, search: search} do
      conn = get(conn, ~p"/searches/#{search}/edit")
      assert html_response(conn, 200) =~ "Edit Search"
    end
  end

  describe "update search" do
    setup [:create_search]

    test "redirects when data is valid", %{conn: conn, search: search} do
      conn = put(conn, ~p"/searches/#{search}", search: @update_attrs)
      assert redirected_to(conn) == ~p"/searches/#{search}"

      conn = get(conn, ~p"/searches/#{search}")
      assert html_response(conn, 200) =~ "some updated tag_slug_list"
    end

    test "renders errors when data is invalid", %{conn: conn, search: search} do
      conn = put(conn, ~p"/searches/#{search}", search: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Search"
    end
  end

  describe "delete search" do
    setup [:create_search]

    test "deletes chosen search", %{conn: conn, search: search} do
      conn = delete(conn, ~p"/searches/#{search}")
      assert redirected_to(conn) == ~p"/searches"

      assert_error_sent 404, fn ->
        get(conn, ~p"/searches/#{search}")
      end
    end
  end

  defp create_search(_) do
    search = search_fixture()
    %{search: search}
  end
end
