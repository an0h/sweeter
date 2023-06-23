defmodule Sweeter.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sweeter.People` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: "some address",
        age: 42,
        email: "some email",
        handle: "some handle",
        name: "some name",
        password: "some password",
        reset_token: "some reset_token"
      })
      |> Sweeter.People.create_user()

    user
  end
end
