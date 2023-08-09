defmodule Sweeter.CitiesTest do
  use Sweeter.DataCase

  alias Sweeter.Cities

  describe "streets" do
    alias Sweeter.Cities.Street

    import Sweeter.CitiesFixtures

    @invalid_attrs %{search: nil}

    test "list_streets/0 returns all streets" do
      street = street_fixture()
      assert Cities.list_streets() == [street]
    end

    test "get_street!/1 returns the street with given id" do
      street = street_fixture()
      assert Cities.get_street!(street.id) == street
    end

    test "create_street/1 with valid data creates a street" do
      valid_attrs = %{search: "some search"}

      assert {:ok, %Street{} = street} = Cities.create_street(valid_attrs)
      assert street.search == "some search"
    end

    test "create_street/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cities.create_street(@invalid_attrs)
    end

    test "update_street/2 with valid data updates the street" do
      street = street_fixture()
      update_attrs = %{search: "some updated search"}

      assert {:ok, %Street{} = street} = Cities.update_street(street, update_attrs)
      assert street.search == "some updated search"
    end

    test "update_street/2 with invalid data returns error changeset" do
      street = street_fixture()
      assert {:error, %Ecto.Changeset{}} = Cities.update_street(street, @invalid_attrs)
      assert street == Cities.get_street!(street.id)
    end

    test "delete_street/1 deletes the street" do
      street = street_fixture()
      assert {:ok, %Street{}} = Cities.delete_street(street)
      assert_raise Ecto.NoResultsError, fn -> Cities.get_street!(street.id) end
    end

    test "change_street/1 returns a street changeset" do
      street = street_fixture()
      assert %Ecto.Changeset{} = Cities.change_street(street)
    end
  end
end
