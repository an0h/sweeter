defmodule SweeterWeb.PageController do
  use SweeterWeb, :controller

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
      _ ->
        conn
        |> render(:home, layout: false)
    end

  end
end
