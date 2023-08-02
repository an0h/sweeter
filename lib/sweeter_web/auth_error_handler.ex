defmodule SweeterWeb.AuthErrorHandler do
  use SweeterWeb, :controller
  alias Plug.Conn

  @spec call(Conn.t(), :not_authenticated) :: Conn.t()
  def call(conn, :not_authenticated) do
    conn
    |> put_flash(:info, "Not Permitted")
    |> redirect(to: "/")
  end
end
