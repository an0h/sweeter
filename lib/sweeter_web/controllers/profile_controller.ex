defmodule SweeterWeb.ProfileController do
  use SweeterWeb, :controller

  alias Sweeter.Repo
  alias Sweeter.Content.Item
  alias Sweeter.Profile.PublerSubser
  alias Sweeter.Users.User

  def show_profile(conn, %{"id" => id}) do
    user = User.get_profile(id)
    authed_user = Pow.Plug.current_user(conn)
    user_authored = Item.get_all_by_user(String.to_integer(id))
    subscribe_action = "/profile/subscribe/" <> id
    unsubscribe_action = "/profile/unsubscribe/" <> id
    is_subscribed = PublerSubser.is_subscribed(user.id, authed_user.id)
    is_own_profile = is_own_profile(user.id, authed_user.id)
    block_action = "/profile/block/" <> id
    subscribed_items = PublerSubser.subscription_feed(String.to_integer(id))
    conn
    |> render(:show, user: user, user_authored: user_authored, subscribed_items: subscribed_items, is_own_profile: is_own_profile, is_subscribed: is_subscribed, subscribe_action: subscribe_action, unsubscribe_action: unsubscribe_action, block_action: block_action)
  end

  def handle_profile(conn, %{"handle" => handle}) do
    user = User.get_handle_profile(handle)
    authed_user = Pow.Plug.current_user(conn)
    id = Integer.to_string(user.id)
    user_authored = Item.get_all_by_user(user.id)
    subscribe_action = "/profile/subscribe/" <> id
    unsubscribe_action = "/profile/unsubscribe/" <> id
    is_subscribed = PublerSubser.is_subscribed(user.id, authed_user.id)
    is_own_profile = is_own_profile(user.id, authed_user.id)
    block_action = "/profile/block/" <> id
    subscribed_items = PublerSubser.subscription_feed(user.id)
    conn
    |> render(:show, user: user, user_authored: user_authored, subscribed_items: subscribed_items, is_own_profile: is_own_profile, is_subscribed: is_subscribed, subscribe_action: subscribe_action, unsubscribe_action: unsubscribe_action, block_action: block_action)
  end

  defp is_own_profile(user_id, authed_user_id) do
    if user_id == authed_user_id do
      true
    else
      false
    end
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

  def unsubscribe(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login")
        |> redirect(to: "/items")
      user ->
        if user.id == id do
          conn
          |> put_flash(:info, "you were NOT subscribed")
          |> redirect(to: "/profile/#{id}")
        else
          case PublerSubser.unsubser(id, user.id) do
            {_, nil} ->
              conn
              |> put_flash(:info, "You were unsubscribed")
              |> redirect(to: "/profile/#{id}")
            {:error} ->
              conn
              |> put_flash(:info, "you were NOT unsubscribed")
              |> redirect(to: "/profile/#{id}")
          end
        end
    end
  end

  def block(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login to block")
        |> redirect(to: "/items")
      user ->
        if user.id == id do
          conn
          |> put_flash(:info, "block not added")
          |> redirect(to: "/profile/#{id}")
        else
          conn
          |> put_flash(:info, "Should have blocked")
          |> redirect(to: "/profile/#{id}")
          # case PublerSubser.subser(id, user.id) do
          #   {:ok, _pubsub} ->
          #     conn
          #     |> put_flash(:info, "You were subscribed")
          #     |> redirect(to: "/profile/#{id}")
          #   {:error, %{}} ->
          #     conn
          #     |> put_flash(:info, "you were NOT subscribed")
          #     |> redirect(to: "/profile/#{id}")
          # end
        end
    end
  end
end
