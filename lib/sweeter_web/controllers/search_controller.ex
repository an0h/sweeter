defmodule SweeterWeb.SearchController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Search
  alias Sweeter.Content.Tag

  def index(conn, _params) do
    query = "Polic"
    search_term = "%#{query}%"
    matches = Search.get_all_query_matches(search_term)
    IO.inspect matches
    IO.puts "matches"
    # searches = Content.list_searches()
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

  def search_by_tag(conn, params) do
    # is restricted or not
    tag = params["tag_slug"]
    [rtids] = Enum.filter(Search.restricted_tag_ids(),
      fn {key, value} -> value == tag end)
      |> Enum.map(fn {key, _v} -> key end)
    IO.inspect params
    # get id from slug
    # Tag.get_tag_ids_by_slug
    items = Search.get_items_by_tag(rtids)
    conn
    render(conn, :results, items: items)
  end
end
