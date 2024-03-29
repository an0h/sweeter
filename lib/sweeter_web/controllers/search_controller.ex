defmodule SweeterWeb.SearchController do
  use SweeterWeb, :controller

  alias Sweeter.Repo
  alias Sweeter.Content
  alias Sweeter.Content.Search
  alias Sweeter.Content.Tag
  alias Sweeter.Profile.PublerSubser

  def index(conn, _params) do
    tags = Search.get_suggested_searches()
    rtags = Search.restricted_tags()
    render(conn, :index, searches: [], tags: tags, rtags: rtags)
  end

  def new(conn, _params) do
    changeset = Content.change_search(%Search{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"search" => search_params}) do
    case Content.create_search(search_params) do
      {:ok, search} ->
        conn
        |> put_flash(:info, "Search created successfully.")
        |> redirect(to: ~p"/searches/#{search}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    search = Content.get_search!(id)
    render(conn, :show, search: search)
  end

  def edit(conn, %{"id" => id}) do
    search = Content.get_search!(id)
    changeset = Content.change_search(search)
    render(conn, :edit, search: search, changeset: changeset)
  end

  def update(conn, %{"id" => id, "search" => search_params}) do
    search = Content.get_search!(id)

    case Content.update_search(search, search_params) do
      {:ok, search} ->
        conn
        |> put_flash(:info, "Search updated successfully.")
        |> redirect(to: ~p"/searches/#{search}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, search: search, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    search = Content.get_search!(id)
    {:ok, _search} = Content.delete_search(search)

    conn
    |> put_flash(:info, "Search deleted successfully.")
    |> redirect(to: ~p"/searches")
  end

  def search_by_term(conn, %{"text" => term}) do
    next = 2
    prev = 0
    search_term = "%#{term}%"
    matches = Search.get_all_query_matches(search_term)
      |> Repo.preload(:images)
      |> Repo.preload(:reactions)
    render(conn, :results, items: matches, page: 1, next: next, prev: prev)
  end

  def search_by_tag(conn, params) do
    next = 2
    prev = 0
    tag = params["tag_slug"]
    if tag != nil do
      tag_id = Tag.get_tag_id_by_slug(tag)
      tag_items = Search.get_items_by_tag(tag_id)
      render(conn, :results, items: tag_items, page: 1, next: next, prev: prev)
    else
      render(conn, :results, items: [], page: 1, next: next, prev: prev)
    end
  end

  def subser_feed(conn, _params) do
    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Login, cant help u here if i dont know u")
        |> redirect(to: "/")

      user ->
        subscribed_items = PublerSubser.subscription_feed(user.id)

        conn
        |> render(:subser_feed, subscribed_items: subscribed_items)
    end
  end

  def popular_tags(conn, _params) do
    tags = Tag.popular_tags()
    json(conn, %{list: tags})
  end
end
