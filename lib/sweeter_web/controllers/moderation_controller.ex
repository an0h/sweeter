defmodule SweeterWeb.ModerationController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Moderation

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
end
