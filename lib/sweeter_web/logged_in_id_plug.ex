defmodule SweeterWeb.LoggedInIdPlug do
  import Plug.Conn

  alias Sweeter.Spicy

  def init(opts), do: opts

  def call(conn, _opts) do
    case Pow.Plug.current_user(conn) do
      nil ->
        assign(conn, :user_id, nil)
        |> assign(:address, nil)
        |> assign(:tokes_balance, nil)
      user ->
        case Spicy.get_tokes_by_address(user.address) do
          {:ok, [balance: balance]} ->
            assign(conn, :user_id, user.id)
            |> assign(:address, user.address)
            |> assign(:tokes_balance, balance)
          {:error} ->
            assign(conn, :user_id, nil)
            |> assign(:address, nil)
            |> assign(:tokes_balance, nil)
      end
    end
  end
end
