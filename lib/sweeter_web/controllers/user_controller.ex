defmodule SweeterWeb.UserController do
  use SweeterWeb, :controller

  alias Sweeter.Content.PublerSubser
  alias Sweeter.API.Credential
  alias Sweeter.People
  alias Sweeter.People.User
  alias Sweeter.People.Guardian
  alias Sweeter.Repo

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
    user = user |> Repo.preload(:api_credentials)
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
          |> redirect(to: "/users/#{id}")
        {:error, %{}} ->
          IO.puts "in the error"
          conn
          |> put_flash(:info, "you were NOT subscribed")
          |> redirect(to: "/users/#{id}")
      end
    end
  end

  def request_api_cred(conn, %{}) do
    loggedin_user = Guardian.Plug.current_resource(conn)
    user_id = loggedin_user.id
    if loggedin_user == nil do
      conn
      |> put_flash(:info, "Login to create api key")
      |> redirect(to: "/login")
    end
    case Credential.create_credential(user_id) do
      {:ok, _cred} ->
        conn
        |> redirect(to: "/users/#{user_id}")
      {:error, %{}} ->
        conn
        |> put_flash(:info, "no api key for you")
        |> redirect(to: "/users/#{user_id}")
    end
  end

  def login(conn, %{}) do
    loggedin_user = Guardian.Plug.current_resource(conn)
    if loggedin_user in [nil] do
      changeset = People.change_user(%User{})
      render(conn, "login.html", changeset: changeset)
    else
      conn
      |> put_flash(:info, "Hello welcome back good to see you.")
      |> redirect(to: ~p"/users/#{loggedin_user}")
    end
  end

  def create_session(conn, %{
    "_csrf_token" => _token,
    "user" => %{"username" => handle, "password" => password}
      }) do
    People.authenticate_user(handle, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Youre logged out, bye.")
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: ~p"/users/#{user}")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
