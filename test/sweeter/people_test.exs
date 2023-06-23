defmodule Sweeter.PeopleTest do
  use Sweeter.DataCase

  alias Sweeter.People

  describe "users" do
    alias Sweeter.People.User

    import Sweeter.PeopleFixtures

    @invalid_attrs %{address: nil, age: nil, email: nil, handle: nil, name: nil, password: nil, reset_token: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert People.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert People.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{address: "some address", age: 42, email: "some email", handle: "some handle", name: "some name", password: "some password", reset_token: "some reset_token"}

      assert {:ok, %User{} = user} = People.create_user(valid_attrs)
      assert user.address == "some address"
      assert user.age == 42
      assert user.email == "some email"
      assert user.handle == "some handle"
      assert user.name == "some name"
      assert user.password == "some password"
      assert user.reset_token == "some reset_token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{address: "some updated address", age: 43, email: "some updated email", handle: "some updated handle", name: "some updated name", password: "some updated password", reset_token: "some updated reset_token"}

      assert {:ok, %User{} = user} = People.update_user(user, update_attrs)
      assert user.address == "some updated address"
      assert user.age == 43
      assert user.email == "some updated email"
      assert user.handle == "some updated handle"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
      assert user.reset_token == "some updated reset_token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_user(user, @invalid_attrs)
      assert user == People.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = People.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> People.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = People.change_user(user)
    end
  end
end
