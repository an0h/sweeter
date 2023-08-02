defmodule Sweeter.ContentTest do
  use Sweeter.DataCase

  alias Sweeter.Content

  describe "items" do
    alias Sweeter.Content.Item

    import Sweeter.ContentFixtures

    @invalid_attrs %{body: nil, deleted: nil, source: nil, title: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Content.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Content.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{body: "some body", deleted: true, source: "some source", title: "some title"}

      assert {:ok, %Item{} = item} = Content.create_item(valid_attrs)
      assert item.body == "some body"
      assert item.deleted == true
      assert item.source == "some source"
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{body: "some updated body", deleted: false, source: "some updated source", title: "some updated title"}

      assert {:ok, %Item{} = item} = Content.update_item(item, update_attrs)
      assert item.body == "some updated body"
      assert item.deleted == false
      assert item.source == "some updated source"
      assert item.title == "some updated title"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_item(item, @invalid_attrs)
      assert item == Content.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Content.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Content.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Content.change_item(item)
    end
  end

  describe "moderations" do
    alias Sweeter.Content.Moderation

    import Sweeter.ContentFixtures

    @invalid_attrs %{category: nil, reason: nil, requestor_id: nil}

    test "list_moderations/0 returns all moderations" do
      moderation = moderation_fixture()
      assert Content.list_moderations() == [moderation]
    end

    test "get_moderation!/1 returns the moderation with given id" do
      moderation = moderation_fixture()
      assert Content.get_moderation!(moderation.id) == moderation
    end

    test "create_moderation/1 with valid data creates a moderation" do
      valid_attrs = %{category: "some category", reason: "some reason", requestor_id: 42}

      assert {:ok, %Moderation{} = moderation} = Content.create_moderation(valid_attrs)
      assert moderation.category == "some category"
      assert moderation.reason == "some reason"
      assert moderation.requestor_id == 42
    end

    test "create_moderation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_moderation(@invalid_attrs)
    end

    test "update_moderation/2 with valid data updates the moderation" do
      moderation = moderation_fixture()
      update_attrs = %{category: "some updated category", reason: "some updated reason", requestor_id: 43}

      assert {:ok, %Moderation{} = moderation} = Content.update_moderation(moderation, update_attrs)
      assert moderation.category == "some updated category"
      assert moderation.reason == "some updated reason"
      assert moderation.requestor_id == 43
    end

    test "update_moderation/2 with invalid data returns error changeset" do
      moderation = moderation_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_moderation(moderation, @invalid_attrs)
      assert moderation == Content.get_moderation!(moderation.id)
    end

    test "delete_moderation/1 deletes the moderation" do
      moderation = moderation_fixture()
      assert {:ok, %Moderation{}} = Content.delete_moderation(moderation)
      assert_raise Ecto.NoResultsError, fn -> Content.get_moderation!(moderation.id) end
    end

    test "change_moderation/1 returns a moderation changeset" do
      moderation = moderation_fixture()
      assert %Ecto.Changeset{} = Content.change_moderation(moderation)
    end
  end

  describe "searches" do
    alias Sweeter.Content.Search

    import Sweeter.ContentFixtures

    @invalid_attrs %{tag_slug_list: nil}

    test "list_searches/0 returns all searches" do
      search = search_fixture()
      assert Content.list_searches() == [search]
    end

    test "get_search!/1 returns the search with given id" do
      search = search_fixture()
      assert Content.get_search!(search.id) == search
    end

    test "create_search/1 with valid data creates a search" do
      valid_attrs = %{tag_slug_list: "some tag_slug_list"}

      assert {:ok, %Search{} = search} = Content.create_search(valid_attrs)
      assert search.tag_slug_list == "some tag_slug_list"
    end

    test "create_search/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_search(@invalid_attrs)
    end

    test "update_search/2 with valid data updates the search" do
      search = search_fixture()
      update_attrs = %{tag_slug_list: "some updated tag_slug_list"}

      assert {:ok, %Search{} = search} = Content.update_search(search, update_attrs)
      assert search.tag_slug_list == "some updated tag_slug_list"
    end

    test "update_search/2 with invalid data returns error changeset" do
      search = search_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_search(search, @invalid_attrs)
      assert search == Content.get_search!(search.id)
    end

    test "delete_search/1 deletes the search" do
      search = search_fixture()
      assert {:ok, %Search{}} = Content.delete_search(search)
      assert_raise Ecto.NoResultsError, fn -> Content.get_search!(search.id) end
    end

    test "change_search/1 returns a search changeset" do
      search = search_fixture()
      assert %Ecto.Changeset{} = Content.change_search(search)
    end
  end
end
