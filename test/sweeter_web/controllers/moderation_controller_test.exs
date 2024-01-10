defmodule SweeterWeb.ModerationControllerTest do
  use SweeterWeb.ConnCase

  import Sweeter.ContentFixtures

  @create_attrs %{category: "some category", reason: "some reason", requestor_id: 42}
  @update_attrs %{category: "some updated category", reason: "some updated reason", requestor_id: 43}
  @invalid_attrs %{category: nil, reason: nil, requestor_id: nil}

  describe "index" do
    test "lists all moderations", %{conn: conn} do
      conn = get(conn, ~p"/moderations")
      assert html_response(conn, 200) =~ "Listing Moderations"
    end
  end

  describe "new moderation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/moderations/new")
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "create moderation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/moderations", moderation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/moderations/#{id}"

      conn = get(conn, ~p"/moderations/#{id}")
      assert html_response(conn, 200) =~ "Moderation #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/moderations", moderation: @invalid_attrs)
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "edit moderation" do
    setup [:create_moderation]

    test "renders form for editing chosen moderation", %{conn: conn, moderation: moderation} do
      conn = get(conn, ~p"/moderations/#{moderation}/edit")
      assert html_response(conn, 200) =~ "Edit Moderation"
    end
  end

  describe "update moderation" do
    setup [:create_moderation]

    test "redirects when data is valid", %{conn: conn, moderation: moderation} do
      conn = put(conn, ~p"/moderations/#{moderation}", moderation: @update_attrs)
      assert redirected_to(conn) == ~p"/moderations/#{moderation}"

      conn = get(conn, ~p"/moderations/#{moderation}")
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "delete moderation" do
    setup [:create_moderation]

    test "deletes chosen moderation", %{conn: conn, moderation: moderation} do
      user = %Sweeter.Users.User{email: "test@example.com", id: 1}
      conn = Pow.Plug.assign_current_user(conn, user, [])

      conn = delete(conn, ~p"/moderations/#{moderation}")
      assert redirected_to(conn) == ~p"/moderations"

      assert_error_sent 404, fn ->
        get(conn, ~p"/moderations/#{moderation}")
      end
    end
  end

  defp create_moderation(_) do
    moderation = moderation_fixture()
    %{moderation: moderation}
  end
end
