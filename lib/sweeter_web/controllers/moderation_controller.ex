defmodule SweeterWeb.ModerationController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Moderation
  alias Sweeter.Content.Tag
  alias Sweeter.Users.User

  def index(conn, _params) do
    moderations = Content.list_moderations()
    render(conn, :index, moderations: moderations)
  end

  def new(conn, _params) do
    changeset = Content.change_moderation(%Moderation{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"moderation" => moderation_params}) do
    case Content.create_moderation(moderation_params) do
      {:ok, moderation} ->
        conn
        |> put_flash(:info, "Moderation created successfully.")
        |> redirect(to: "/items/#{moderation.item_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    moderation = Content.get_moderation!(id)
    render(conn, :show, moderation: moderation)
  end

  def edit(conn, %{"id" => id}) do
    moderation = Content.get_moderation!(id)
    changeset = Content.change_moderation(moderation)
    render(conn, :edit, moderation: moderation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "moderation" => moderation_params}) do
    # moderation = Content.get_moderation!(id)

    # case Content.update_moderation(moderation, moderation_params) do
    #   {:ok, moderation} ->
        conn
        |> put_flash(:info, "Moderation successfully.")
        |> redirect(to: ~p"/moderations/")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :edit, moderation: moderation, changeset: changeset)
    # end
  end

  def delete(conn, %{"id" => id}) do
    # moderation = Content.get_moderation!(id)
    # {:ok, _moderation} = Content.delete_moderation(moderation)

    conn
    |> put_flash(:info, "Moderation successfully.")
    |> redirect(to: ~p"/moderations")
  end

  def new_tag(conn, %{}) do
    case User.get_is_moderator(conn) do
      true ->
        changeset = Tag.changeset(%Tag{},%{})
        render(conn, :add_tag, changeset: changeset)
      false ->
        conn
        |> put_flash(:info, "youre not a mod")
        |> redirect(to: ~p"/items")
    end
  end

  def create_tag(conn, %{"tag" => tag}) do
    case User.get_moderator_id(conn) do
      false ->
        conn
        |> put_flash(:info, "youre not a mod")
        |> redirect(to: ~p"/items")
      user_id ->
        tag = Map.put(tag, "submitted_by", user_id)
          |> Map.put("slug", Tag.convert_to_slug(tag["label"]))
        Tag.create_tag(tag)
        conn
        |> put_flash(:info, "tag created")
        |> redirect(to: ~p"/moderator/list_tags")
    end
  end

  def list_tags(conn, _params) do
    case User.get_moderator_id(conn) do
      false ->
        conn
        |> put_flash(:info, "youre not a mod")
        |> redirect(to: ~p"/items")
      user_id ->
        tags = Tag.get_all_submitted_by(user_id)
        render(conn, :list_tags, tags: tags)
    end
  end
end
