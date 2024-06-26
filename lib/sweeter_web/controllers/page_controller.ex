defmodule SweeterWeb.PageController do
  use SweeterWeb, :controller

  alias Sweeter.Repo
  alias Sweeter.Content.Item
  # alias Sweeter.Content.Search
  alias Sweeter.Content.Tag
  # alias Sweeter.Profile.PublerSubser
  alias Sweeter.Users.User

  def home(conn, _params) do
    next = 2
    prev = 0
    featured = Item.get_featured_items()
    case Pow.Plug.current_user(conn) do
      nil ->
        items = Item.get_all_logged_out(50, "1")
          |> Repo.preload(:images)
          |> Repo.preload(:reactions)
        render(conn, :home, items: items, page: 1, next: next, prev: prev, featured: featured)
      user ->
        profile = User.get_profile(user.id)
        cond do
        profile.address == nil ->
          conn
          |> put_flash(:info, "Get an address! for the blockchain fun game part.")
          |> redirect(to: "/mnemonic")
        profile.handle == nil ->
          conn
          |> put_flash(:info, "Update your profile, you really need to set a handle pls")
          |> redirect(to: "/profile/edit/#{user.id}")
        true ->
          items = Item.get_all_logged_in(user.id)
          |> Repo.preload(:images)
          |> Repo.preload(:reactions)

          render(conn, :home, items: items, page: 1, next: next, prev: prev, featured: featured)
        end
    end
  end

  def about(conn, _params) do
    inspect(Node.list())
    conn
    |> render(:about)
  end

  def about_api(conn, _params) do
    conn
    |> render(:about_api)
  end

  def about_anon(conn, _params) do
    conn
    |> render(:about_anon)
  end

  def about_tech(conn, _params) do
    conn
    |> render(:about_tech)
  end

  def about_mod(conn, _params) do
    conn
    |> render(:about_mod)
  end

  def energy(conn, _params) do
    conn
    |> render(:energy)
  end

  def plans(conn, _params) do
    conn
    |> render(:plans)
  end

  def privacy(conn, _params) do
    conn
    |> render(:privacy)
  end
end
