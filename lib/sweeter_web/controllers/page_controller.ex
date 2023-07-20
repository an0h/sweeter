defmodule SweeterWeb.PageController do
  use SweeterWeb, :controller
  alias Sweeter.Content.PublerSubser

  def home(conn, _params) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> render(:home, layout: false)
      user ->
        IO.inspect user
        if user.address == nil do
          conn
          |> put_flash(:info, "Get an address! for the blockchain fun game part.")
          |> redirect(to: "/mnemonic")
        else
          conn
          |> render(:home, layout: false)
        end
    end
  end

  def about_api(conn, _params) do
    conn
    |> render(:about_api, layout: false)
  end

  def about_anon(conn, _params) do
    conn
    |> render(:about_anon, layout: false)
  end

  def energy(conn, _params) do
    conn
    |> render(:energy, layout: false)
  end

  def privacy(conn, _params) do
    conn
    |> render(:privacy, layout: false)
  end

  def subscribe(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login to create subscriptions")
        |> redirect(to: "/users/#{id}")
      user ->
        case PublerSubser.subser(id, loggedin_user.id) do
          {:ok, _pubsub} ->
            conn
            |> put_flash(:info, "You were subscribed")
            |> redirect(to: "/users/#{id}")
          {:error, %{}} ->
            conn
            |> put_flash(:info, "you were NOT subscribed")
            |> redirect(to: "/users/#{id}")
        end
    end
  end
end
