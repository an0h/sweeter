defmodule SweeterWeb.ProfileController do
  use SweeterWeb, :controller

  alias Sweeter.Users.User

  def show_profile(conn, %{"id" => id}) do
    user = User.get_profile(id)
    IO.inspect user
    IO.puts user.address
    IO.puts "i was here"
    conn
    |> render(:show, user: user, address: user.address)
  end
end
