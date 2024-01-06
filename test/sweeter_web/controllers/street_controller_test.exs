defmodule SweeterWeb.StreetControllerTest do
  use SweeterWeb.ConnCase

  import Sweeter.CitiesFixtures

  @create_attrs %{search: "some search"}
  @update_attrs %{search: "some updated search"}
  @invalid_attrs %{search: nil}

  describe "index" do
    test "lists all streets", %{conn: conn} do
      conn = get(conn, ~p"/streets")
      assert html_response(conn, 200) =~ "Help build internetstate.city! Check out the Elixir repo:"
    end
  end

  describe "new street" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/streets/new")
      assert html_response(conn, 200) =~ "New Street"
    end
  end

  describe "create street" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/streets", street: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/streets/#{id}"

      conn = get(conn, ~p"/streets/#{id}")
      assert html_response(conn, 200) =~ "Street #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/streets", street: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Street"
    end
  end

  describe "edit street" do
    setup [:create_street]

    test "renders form for editing chosen street", %{conn: conn, street: street} do
      conn = get(conn, ~p"/streets/#{street}/edit")
      assert html_response(conn, 200) =~ "Edit Street"
    end
  end

  describe "update street" do
    setup [:create_street]

    test "redirects when data is valid", %{conn: conn, street: street} do
      conn = put(conn, ~p"/streets/#{street}", street: @update_attrs)
      assert redirected_to(conn) == ~p"/streets/#{street}"

      conn = get(conn, ~p"/streets/#{street}")
      assert html_response(conn, 200) =~ "some updated search"
    end

    test "renders errors when data is invalid", %{conn: conn, street: street} do
      conn = put(conn, ~p"/streets/#{street}", street: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Street"
    end
  end

  describe "delete street" do
    setup [:create_street]

    test "deletes chosen street", %{conn: conn, street: street} do
      conn = delete(conn, ~p"/streets/#{street}")
      assert redirected_to(conn) == ~p"/streets"

      assert_error_sent 404, fn ->
        get(conn, ~p"/streets/#{street}")
      end
    end
  end

  defp create_street(_) do
    street = street_fixture()
    %{street: street}
  end
end
