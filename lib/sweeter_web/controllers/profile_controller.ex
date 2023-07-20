defmodule SweeterWeb.ProfileController do
  use SweeterWeb, :controller

  alias Sweeter.Users.User

  def show_profile(conn, %{"id" => id}) do
    user = User.get_profile(id)
    conn
    |> render(:show, user: user)
  end

  def edit_profile(conn, %{"id" => id}) do
    user = User.get_profile(id)
    changeset = User.change_user(user)
    conn
    |> render(:edit, user: user, changeset: changeset)
  end

  def update_profile(conn, params) do
    IO.inspect params
    # changeset = Content.change_item(item)
    conn
    |> put_flash(:info, "Updated")
    |> redirect(to: "/users/#{params.id}")
  end
end
