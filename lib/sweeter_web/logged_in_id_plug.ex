defmodule SweeterWeb.LoggedInIdPlug do
  import Plug.Conn

  alias Sweeter.Spicy
  alias Sweeter.Users.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case Pow.Plug.current_user(conn) do
      nil ->
        assign(conn, :user_id, nil)
        |> assign(:address, nil)
        |> assign(:tokes_balance, nil)
      user ->
        profile = User.get_profile(user.id)
        case Spicy.get_tokes_by_address(profile.address) do
          {:ok, [balance: balance]} ->
            assign(conn, :user_id, user.id)
            |> assign(:address, profile.address)
            |> assign(:tokes_balance, balance)
          {:error} ->
            assign(conn, :user_id, nil)
            |> assign(:address, nil)
            |> assign(:tokes_balance, nil)
      end
    end
  end
end
