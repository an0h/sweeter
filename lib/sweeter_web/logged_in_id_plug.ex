defmodule SweeterWeb.LoggedInIdPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Pow.Plug.current_user(conn) do
      nil ->
        assign(conn, :user_id, nil)
      user ->
        assign(conn, :user_id, user.id)
    end
  end
end
