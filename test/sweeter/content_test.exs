defmodule Sweeter.ContentTest do
  use Sweeter.DataCase

  alias Sweeter.Content

  describe "items" do
    alias Sweeter.Content.Item

    import Sweeter.ContentFixtures

    @invalid_attrs %{body: nil, deleted: nil, format: nil, source: nil, title: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Content.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Content.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{body: "some body", deleted: true, format: "some format", source: "some source", title: "some title"}

      assert {:ok, %Item{} = item} = Content.create_item(valid_attrs)
      assert item.body == "some body"
      assert item.deleted == true
      assert item.format == "some format"
      assert item.source == "some source"
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{body: "some updated body", deleted: false, format: "some updated format", source: "some updated source", title: "some updated title"}

      assert {:ok, %Item{} = item} = Content.update_item(item, update_attrs)
      assert item.body == "some updated body"
      assert item.deleted == false
      assert item.format == "some updated format"
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
end
