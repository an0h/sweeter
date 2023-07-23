defmodule SweeterWeb.ItemController do
  use SweeterWeb, :controller

  alias Sweeter.Repo
  alias Sweeter.Content
  alias Sweeter.Content.Item
  alias Sweeter.Content.Reactions
  alias Sweeter.Users.User

  def index(conn, _params) do
    items = Item.get_all()
    render(conn, :index, items: items)
  end

  def new(conn, _params) do
    changeset = Content.change_item(%Item{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Item.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: ~p"/items/#{item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Content.get_item!(id) |> Repo.preload(:images)
    reactions = Reactions.get_reactions_for_item(id)
    item = %{item | reactions: reactions}

    case Pow.Plug.current_user(conn) do
      nil ->
        conn
        |> render(:show, item: item, address: "")
      user ->
        conn
        |> render(:show, item: item, address: user.address)
    end
  end

  def edit(conn, %{"id" => _id}) do
    not_allowed(conn)
    # item = Content.get_item!(id)
    # changeset = Content.change_item(item)
    # render(conn, :edit, item: item, changeset: changeset)
  end

  def update(conn, %{"id" => _id, "item" => _item_params}) do
    not_allowed(conn)
    # item = Content.get_item!(id)

    # case Content.update_item(item, item_params) do
    #   {:ok, item} ->
    #     conn
    #     |> put_flash(:info, "Item updated successfully.")
    #     |> redirect(to: ~p"/items/#{item}")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :edit, item: item, changeset: changeset)
    # end
  end

  def delete(conn, %{"id" => id}) do
    case User.get_is_admin(conn) do
      true ->
        item = Content.get_item!(id)
        {:ok, _item} = Content.delete_item(item)

        conn
        |> put_flash(:info, "Item deleted successfully.")
        |> redirect(to: ~p"/items")
      false ->
        not_allowed(conn)
      nil ->
        not_allowed(conn)
    end
  end

  defp not_allowed(conn) do
    conn
    |> put_flash(:info, "Nope, nada.")
    |> redirect(to: ~p"/items")
  end
end
