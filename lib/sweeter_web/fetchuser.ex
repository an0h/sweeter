defmodule SweeterWeb.Fetchuser do
  alias Sweeter.People.Guardian
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    loggedin_user = Guardian.Plug.authenticated?(conn)
    IO.inspect loggedin_user
    if loggedin_user == false do
      assign(conn, :plug_user_loggedin, false)
    else
      assign(conn, :plug_user_loggedin, true)
    end
  end
end
