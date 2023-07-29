defmodule SweeterWeb.ModeratorPlug do
  import Plug.Conn

  alias Sweeter.Users.User

  def init(opts), do: opts

  def call(conn, _opts) do
    mod = User.get_is_moderator(conn)
    IO.inspect  mod
    IO.puts "disidsi"
    case User.get_is_moderator(conn) do
      true ->
        conn
      false ->
        conn
        |> Phoenix.Controller.redirect(to: "/items")
        |> Plug.Conn.halt()
    end
  end
end
