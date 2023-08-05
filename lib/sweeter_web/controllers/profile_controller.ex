defmodule SweeterWeb.ProfileController do
  use SweeterWeb, :controller

  alias Sweeter.Content.Item
  alias Sweeter.Content.PublerSubser
  alias Sweeter.Users.User
  alias Sweeter.Spicy

  def show_profile(conn, %{"id" => id}) do
    user = User.get_profile(id)
    user_authored = Item.get_all_by_user(String.to_integer(id))
    subscribe_action = "/profile/subscribe/" <> id
    # tokes = Spicy.get_cosmos_by_address(user.address)
    # IO.inspect(tokes)
    subscribed_items = PublerSubser.subscription_feed(String.to_integer(id))
    conn
    |> render(:show, user: user, user_authored: user_authored, subscribed_items: subscribed_items, subscribe_action: subscribe_action)
  end

  def handle_profile(conn, %{"handle" => handle}) do
    user = User.get_handle_profile(handle)
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

  def subscribe(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login to create subscriptions")
        |> redirect(to: "/items")
      user ->
        if user.id == id do
          conn
          |> put_flash(:info, "you were NOT subscribed")
          |> redirect(to: "/profile/#{id}")
        else
          case PublerSubser.subser(id, user.id) do
            {:ok, _pubsub} ->
              conn
              |> put_flash(:info, "You were subscribed")
              |> redirect(to: "/profile/#{id}")
            {:error, %{}} ->
              conn
              |> put_flash(:info, "you were NOT subscribed")
              |> redirect(to: "/profile/#{id}")
          end
        end
    end
  end
end
