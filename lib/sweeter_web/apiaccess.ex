defmodule SweeterWeb.APIaccess do
  import Plug.Conn
  alias Sweeter.API.Credential

  def init(default), do: default

  def call(conn, _default) do
    if Credential.check_credential(get_req_header(conn, "key")) do
      conn
    else
      conn
      |> halt()
    end
  end
end
