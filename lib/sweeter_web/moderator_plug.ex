defmodule SweeterWeb.ModeratorPlug do
  alias Sweeter.Users.User

  def init(opts), do: opts

  def call(conn, _opts) do
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
