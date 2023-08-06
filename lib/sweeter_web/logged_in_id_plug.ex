defmodule SweeterWeb.LoggedInIdPlug do
  import Plug.Conn

  alias Sweeter.Spicy

  def init(opts), do: opts

  def call(conn, _opts) do
    case Pow.Plug.current_user(conn) do
      nil ->
        IO.puts "der your ogged out"
        assign(conn, :user_id, nil)
      user ->
        balance = Spicy.get_tokes_by_address(user.address)
        IO.inspect balance
        IO.puts "balanace balance"
        assign(conn, :user_id, user.id)
        |> assign(:address, user.address)
        |> assign(:tokes_balance, balance)
    end
  end
end
