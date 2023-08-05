defmodule SweeterWeb.PageController do
  use SweeterWeb, :controller

  def home(conn, _params) do
    nodes = inspect(Node.list())
    IO.inspect nodes
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> render(:home)
      user ->
        if user.address == nil do
          conn
          |> put_flash(:info, "Get an address! for the blockchain fun game part.")
          |> redirect(to: "/mnemonic")
        else
          conn
          |> render(:home)
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

  def about_mod(conn, _params) do
    conn
    |> render(:about_mod)
  end

  def energy(conn, _params) do
    conn
    |> render(:energy)
  end

  def privacy(conn, _params) do
    conn
    |> render(:privacy)
  end
end
