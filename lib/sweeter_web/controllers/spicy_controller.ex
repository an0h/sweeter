defmodule SweeterWeb.SpicyController do
  use SweeterWeb, :controller

  alias Sweeter.Users.User
  alias Sweeter.CreditDebit
  alias Sweeter.Spicy
  alias Sweeter.Repo

  def get_mnemonic(conn, _params) do
    changeset = %{}
    render(conn, :get, changeset: changeset, action: ~p"/show_mnemonic/")
  end

  def show_mnemonic(conn, params) do
    user = Pow.Plug.current_user(conn)
    if user == nil do
      conn
      |> put_flash(:error, "You aren't logged in? Por K? did u validate email?")
      |> render(:show, mnemonic: '', address: '')
    else
      %{"_csrf_token" =>  _, "mnemonic" => mnemonic} = params
      with {:ok, address: address, mnemonic: mnemonic} <- Spicy.get_new_user_address(user.email, mnemonic) do
        User.change_user_address(user, address) |> Repo.update()
        CreditDebit.u_get_a_token(address)
        render(conn, :show, mnemonic: mnemonic, address: address)
      else
        e ->
          IO.inspect e
          render(conn, :show, mnemonic: '', address: '')
      end
    end
  end

end
