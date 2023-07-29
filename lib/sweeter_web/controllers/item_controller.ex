defmodule SweeterWeb.ItemController do
  use SweeterWeb, :controller

  alias Sweeter.Repo
  alias Sweeter.Content
  alias Sweeter.Content.Item
  alias Sweeter.Content.LoadCounts
  alias Sweeter.Content.Moderation
  alias Sweeter.Content.Reactions
  alias Sweeter.Content.Tag
  alias Sweeter.Content.RestrictedTag
  alias Sweeter.Users.User

  def index(conn, _params) do
    items = Item.get_all()
    render(conn, :index, items: items)
  end

  def new(conn, _params) do
    changeset = Content.change_item(%Item{})
    known_tags = Tag.get_all()
    render(conn, :new, changeset: changeset, known_tags: known_tags)
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
    item = Content.get_item!(id)
      |> Repo.preload(:images)
      |> Repo.preload(:moderations)
    reactions = Reactions.get_reactions_for_item(id)
    item = %{item | reactions: reactions}
    restricted_tags = RestrictedTag.get_restricted_tag_labels_for_item(String.to_integer(id))
    tags = Tag.get_tag_labels_for_item(String.to_integer(id))
    item_load_count = LoadCounts.fetch_item_load_count(id)

    case Pow.Plug.current_user(conn) do
      nil ->
        LoadCounts.increment_item_load_count(id)
        conn
        |> render(:show,
          item: item,
          restricted_tags: restricted_tags,
          tags: tags,
          address: "",
          item_load_count: item_load_count,
          is_moderator: false,
          moderation_changeset: %Moderation{})
      user ->
        LoadCounts.increment_item_load_count(id, user.id)
        is_moderator = User.get_is_moderator(conn)
        moderation_changeset = Content.change_moderation(%Moderation{},
          %{"item_id" => item.id, "requestor_id" => user.id})
        conn
        |> render(:show,
          item: item,
          restricted_tags: restricted_tags,
          item_load_count: item_load_count,
          tags: tags,
          address: user.address,
          is_moderator: is_moderator,
          moderation_changeset: moderation_changeset)
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
    case User.get_is_moderator(conn) do
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
