defmodule SweeterWeb.Fetchuser do
  alias Sweeter.People.Guardian
  import Plug.Conn

  def init(default), do: default

  def call(conn,_default) do
    loggedin_user = Guardian.Plug.current_resource(conn)
    if loggedin_user != nil do
      assign(conn, :loggedin_user, loggedin_user)
    else
      assign(conn, :loggedin_user, nil)
    end
  end
end
