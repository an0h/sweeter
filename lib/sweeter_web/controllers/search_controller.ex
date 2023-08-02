defmodule SweeterWeb.SearchController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Search

  def index(conn, _params) do
    query = "Polic"
    search_term = "%#{query}%"
    matches = Search.get_all_query_matches(search_term)
    IO.inspect matches
    IO.puts "matches"
    # searches = Content.list_searches()
    tag_slugs = Search.get_suggested_searches()
    rt_slugs = Search.restricted_tag_slugs()
    render(conn, :index, searches: [], tag_slugs: tag_slugs, rt_slugs: rt_slugs)
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
end
