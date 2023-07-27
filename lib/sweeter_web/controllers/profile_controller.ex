defmodule SweeterWeb.ProfileController do
  use SweeterWeb, :controller

  alias Sweeter.Users.User
  alias Sweeter.Spicy

  def show_profile(conn, %{"id" => id}) do
    user = User.get_profile(id)
    # tokes = Spicy.get_cosmos_by_address(user.address)
    # IO.inspect(tokes)
    conn
    |> render(:show, user: user)
  end

  def edit_profile(conn, %{"id" => id}) do
    authed_user = Pow.Plug.current_user(conn)
    {user_id, _} = Integer.parse(id)
    if authed_user.id == user_id do
      user = User.get_profile(id)
      changeset = User.change_user(user)
      conn
      |> render(:edit, user: user, changeset: changeset)
    else
      # @TODO debit a toke
      conn
      |> put_flash(:info, "Naughty.")
      |> redirect(to: "/")
    end
  end

  def update_profile(conn, %{"user" => params}) do
    authed_user = Pow.Plug.current_user(conn)
    {user_id, _} = Integer.parse(params["id"])
    if authed_user.id == user_id do
      user = User.get_profile(user_id)
      result = User.change_user_profile(user, params)
      IO.inspect result
      IO.puts "change result"
      conn
      |> put_flash(:info, "Updated")
      |> redirect(to: "/profile/#{params["id"]}")
    else
      # @TODO debit a toke
      conn
      |> put_flash(:info, "Naughty.")
      |> redirect(to: "/")
    end
  end
end
