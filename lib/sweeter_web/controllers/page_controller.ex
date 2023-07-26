defmodule SweeterWeb.PageController do
  use SweeterWeb, :controller
  alias Sweeter.Content.PublerSubser

  def home(conn, _params) do
    nodes = inspect(Node.list())
    IO.inspect nodes
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> render(:home, layout: false)
      user ->
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
    |> render(:about_api)
  end

  def about_anon(conn, _params) do
    conn
    |> render(:about_anon)
  end

  def about_tech(conn, _params) do
    conn
    |> render(:about_tech)
  end

  def energy(conn, _params) do
    conn
    |> render(:energy)
  end

  def privacy(conn, _params) do
    conn
    |> render(:privacy)
  end

  def subscribe(conn, %{"id" => id}) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login to create subscriptions")
        |> redirect(to: "/users/#{id}")
      user ->
        case PublerSubser.subser(id, user.id) do
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
