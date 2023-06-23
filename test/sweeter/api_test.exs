defmodule Sweeter.APITest do
  use Sweeter.DataCase

  alias Sweeter.API

  describe "feeds" do
    alias Sweeter.API.Feed

    import Sweeter.APIFixtures

    @invalid_attrs %{search: nil}

    test "list_feeds/0 returns all feeds" do
      feed = feed_fixture()
      assert API.list_feeds() == [feed]
    end

    test "get_feed!/1 returns the feed with given id" do
      feed = feed_fixture()
      assert API.get_feed!(feed.id) == feed
    end

    test "create_feed/1 with valid data creates a feed" do
      valid_attrs = %{search: "some search"}

      assert {:ok, %Feed{} = feed} = API.create_feed(valid_attrs)
      assert feed.search == "some search"
    end

    test "create_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = API.create_feed(@invalid_attrs)
    end

    test "update_feed/2 with valid data updates the feed" do
      feed = feed_fixture()
      update_attrs = %{search: "some updated search"}

      assert {:ok, %Feed{} = feed} = API.update_feed(feed, update_attrs)
      assert feed.search == "some updated search"
    end

    test "update_feed/2 with invalid data returns error changeset" do
      feed = feed_fixture()
      assert {:error, %Ecto.Changeset{}} = API.update_feed(feed, @invalid_attrs)
      assert feed == API.get_feed!(feed.id)
    end

    test "delete_feed/1 deletes the feed" do
      feed = feed_fixture()
      assert {:ok, %Feed{}} = API.delete_feed(feed)
      assert_raise Ecto.NoResultsError, fn -> API.get_feed!(feed.id) end
    end

    test "change_feed/1 returns a feed changeset" do
      feed = feed_fixture()
      assert %Ecto.Changeset{} = API.change_feed(feed)
    end
  end
end
