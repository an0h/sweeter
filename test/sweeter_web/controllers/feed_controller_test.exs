defmodule SweeterWeb.FeedControllerTest do
  use SweeterWeb.ConnCase

  import Sweeter.APIFixtures

  alias Sweeter.API.Feed

  @create_attrs %{
    search: "some search"
  }
  @update_attrs %{
    search: "some updated search"
  }
  @invalid_attrs %{search: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all feeds", %{conn: conn} do
      conn = get(conn, ~p"/api/feeds")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create feed" do
    test "renders feed when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/feeds", feed: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/feeds/#{id}")

      assert %{
               "id" => ^id,
               "search" => "some search"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/feeds", feed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update feed" do
    setup [:create_feed]

    test "renders feed when data is valid", %{conn: conn, feed: %Feed{id: id} = feed} do
      conn = put(conn, ~p"/api/feeds/#{feed}", feed: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/feeds/#{id}")

      assert %{
               "id" => ^id,
               "search" => "some updated search"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, feed: feed} do
      conn = put(conn, ~p"/api/feeds/#{feed}", feed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete feed" do
    setup [:create_feed]

    test "deletes chosen feed", %{conn: conn, feed: feed} do
      conn = delete(conn, ~p"/api/feeds/#{feed}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/feeds/#{feed}")
      end
    end
  end

  defp create_feed(_) do
    feed = feed_fixture()
    %{feed: feed}
  end
end
