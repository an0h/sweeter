defmodule SweeterWeb.CssCustomizerPlug do
  import Plug.Conn

  alias Sweeter.Users.User

  def init(opts), do: opts

  def call(conn, opts) do
    case conn.path_info do
      [ _ , id ] ->
        IO.inspect id
        user = User.get_profile(id)
        path = "https://sweetipfs.herokuapp.com/custom.css?ipfscid=#{user.css_ipfscid}"
        assign(conn, :css_sheet_path, path)
      [ handle ] ->
        IO.inspect handle
        user = User.get_handle_profile(handle)
        path = "https://sweetipfs.herokuapp.com/custom.css?ipfscid=#{user.css_ipfscid}"
        assign(conn, :css_sheet_path, path)
    end
  end
end
