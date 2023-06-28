defmodule SweeterWeb.UserController do
  use SweeterWeb, :controller

  alias Phoenix.PubSub
  alias Sweeter.Content.PublerSubler
  alias Sweeter.People
  alias Sweeter.People.User
  alias Sweeter.People.Guardian

  def index(conn, _params) do
    users = People.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    changeset = People.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case People.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # People.get_a_mnemonic()
    loggedin_user = Guardian.Plug.current_resource(conn)
    user = People.get_user!(id)
    render(conn, :show, user: user, loggedin_user: loggedin_user, subscribe_link: "/users/subscribe/#{id}")
  end

  def edit(conn, %{"id" => id}) do
    user = People.get_user!(id)
    changeset = People.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = People.get_user!(id)

    case People.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = People.get_user!(id)
    {:ok, _user} = People.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end

  def login(conn, %{}) do
    changeset = People.change_user(%User{})
    render(conn, :login, changeset: changeset)
  end

  def create_session(conn, attrs) do
    %{"user" => %{"username" => username, "password" => password}} = attrs
    conn
    |> redirect(to: ~p"/users")
  end

  def subscribe(conn, %{"id" => id}) do
    IO.inspect id
    IO.puts "idabove"
    loggedin_user = Guardian.Plug.current_resource(conn)
    IO.inspect loggedin_user
    IO.puts "loggedinuser"
    if loggedin_user == nil do
      IO.puts "why not here"
      conn
      |> put_flash(:info, "Login to create subscriptions")
      |> redirect(to: "/users/#{id}")
    else
      case PublerSubser.subser(id, loggedin_user.id) do
        {:ok, _pubsub} ->
          IO.puts "in the ok"
          conn
          |> put_flash(:info, "You were subscribed")
          |> redirect(to: ~p"/users/#{id}")
        {:error, %{}} ->
          IO.puts "in the error"
          conn
          |> put_flash(:info, "you were NOT subscribed")
          |> redirect(to: ~p"/users/#{id}")
      end
    end
  end
end
