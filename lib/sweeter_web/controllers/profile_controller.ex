defmodule SweeterWeb.ProfileController do
  use SweeterWeb, :controller

  # alias Sweeter.Repo
  alias Sweeter.Content.CssSheet
  alias Sweeter.Content.Item
  alias Sweeter.Profile.Block
  alias Sweeter.Profile.PublerSubser
  alias Sweeter.Users.User
  alias Sweeter.Censor.Records
  # alias Sweeter.CreditDebit
  # alias Sweeter.Spicy

  def show_profile(conn, %{"id" => id}) do
    case User.get_profile(id) do
      nil ->
        conn
        |> put_flash(:error, "User not found")
        |> redirect(to: "/items")
      user ->
        authed_user = Pow.Plug.current_user(conn)
        IO.inspect user
        IO.inspect authed_user
        if Block.is_blocked(authed_user.id, user.id) == true do
          conn
          |> put_flash(:info, "Not available")
          |> redirect(to: "/items")
        else
          serve_profile(conn, id, user, authed_user)
        end
    end
  end

  def handle_profile(conn, %{"handle" => handle}) do
    case User.get_handle_profile(handle) do
      nil ->
        conn
        |> put_flash(:error, "User not found")
        |> redirect(to: "/items")
      user ->
        authed_user = Pow.Plug.current_user(conn)
        if Block.is_blocked(authed_user.id, user.id) == true do
          conn
          |> put_flash(:info, "Not available")
          |> redirect(to: "/items")
        else
          serve_profile(conn, Integer.to_string(user.id), user, authed_user)
        end
    end
  end

  defp serve_profile(conn, id, user, authed_user) do
    user_authored = Item.get_all_by_user(String.to_integer(id))
    subscribe_action = "/profile/subscribe/" <> id
    unsubscribe_action = "/profile/unsubscribe/" <> id
    is_subscribed = PublerSubser.is_subscribed(user.id, authed_user.id)
    is_own_profile = is_own_profile(user.id, authed_user.id)
    block_action = "/profile/block/" <> id
    unblock_action = "/profile/unblock/" <> id
    blocked = Block.is_blocked(user.id, authed_user.id)
    subscribed_items = PublerSubser.subscription_feed(String.to_integer(id))
    censor_action = "/profile/censor/" <> id
    conn
    |> render(:show,
      user: user,
      user_authored: user_authored,
      subscribed_items: subscribed_items,
      is_own_profile: is_own_profile,
      is_subscribed: is_subscribed,
      subscribe_action: subscribe_action,
      unsubscribe_action: unsubscribe_action,
      block_action: block_action,
      unblock_action: unblock_action,
      censor_action: censor_action,
      blocked: blocked)
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
      cssStyles = CssSheet.list_styles()
      IO.inspect cssStyles
      conn
      |> render(:edit, user: user, changeset: changeset, cssStyles: cssStyles)
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
      User.change_user_profile(user, params)
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
          case Block.create_block(id, user.id) do
            {:ok, _block} ->
              conn
              |> put_flash(:info, "blocked")
              |> redirect(to: "/profile/#{id}")
            {:error, %{}} ->
              conn
              |> put_flash(:info, "unsuccessful")
              |> redirect(to: "/profile/#{id}")
          end
        end
    end
  end

  def unblock(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login")
        |> redirect(to: "/items")
      user ->
        if user.id == id do
          conn
          |> put_flash(:info, "no block")
          |> redirect(to: "/profile/#{id}")
        else
          case Block.unblock(id, user.id) do
            {_, nil} ->
              conn
              |> put_flash(:info, "Unblocked")
              |> redirect(to: "/profile/#{id}")
            {:error} ->
              conn
              |> put_flash(:info, "unsuccessful")
              |> redirect(to: "/profile/#{id}")
          end
        end
    end
  end

  def censor(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login")
        |> redirect(to: "/items")
      user ->
        if user.id == id do
          conn
          |> put_flash(:info, "you cant censor yourself")
          |> redirect(to: "/profile/#{id}")
        else
          # profile = User.get_profile(id)
          Records.make_record("comment", user.id, id)
          handle = User.get_handle_from_id(id)
          # Spicy.take_spicy_token(profile.address, profile.seed_phrase, 1)
          conn
          |> render(:censored, handle: handle)
        end
    end
  end
end
