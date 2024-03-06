defmodule SweeterWeb.CssCustomizerPlug do
  import Plug.Conn

  alias Sweeter.Users.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.path_info do
      [ _ , id ] ->
        case User.get_profile(id) do
          nil ->
            assign(conn, :css_sheet_path, '')
          user ->
            path = "https://sweetipfs.herokuapp.com/custom.css?ipfscid=#{user.css_ipfscid}"
            assign(conn, :css_sheet_path, path)
        end
      [ handle ] ->
        case User.get_handle_profile(handle) do
          nil ->
            assign(conn, :css_sheet_path, '')
          user ->
            path = "https://sweetipfs.herokuapp.com/custom.css?ipfscid=#{user.css_ipfscid}"
            assign(conn, :css_sheet_path, path)
        end
    end
  end
end
