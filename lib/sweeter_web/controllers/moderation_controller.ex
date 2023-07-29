defmodule SweeterWeb.ModerationController do
  use SweeterWeb, :controller

  alias Sweeter.Content
  alias Sweeter.Content.Moderation
  alias Sweeter.Content.Tag

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

  def new_tag(conn, _params) do
    changeset = Tag.change_tag(%Tag{})
    render(conn, :add_tag, changeset: changeset)
  end

  def create_tag(conn, %{"tag" => %{"label" => label}}) do
    case Tag.create_tag(%{"label" => label, "slug" => convert_to_slug(label)}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "#{label} was created")
        |> redirect(to: ~p"/items/new")

      e ->
        conn
        |> put_flash(:info, "your tag was not created")
        |> redirect(to: ~p"/items/new")
    end
  end

  defp convert_to_slug(label) do
    label
    |> String.downcase()                     # Convert to lowercase
    |> String.replace(~r/[^a-zA-Z0-9\s]/, "") # Remove anything that isn't a letter or number
    |> String.replace(~r/\s+/, "_")          # Replace spaces with underscores
    |> String.trim("_")                      # Trim underscores from the beginning and end
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
    moderation = Content.get_moderation!(id)

    case Content.update_moderation(moderation, moderation_params) do
      {:ok, moderation} ->
        conn
        |> put_flash(:info, "Moderation updated successfully.")
        |> redirect(to: ~p"/moderations/#{moderation}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, moderation: moderation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    moderation = Content.get_moderation!(id)
    {:ok, _moderation} = Content.delete_moderation(moderation)

    conn
    |> put_flash(:info, "Moderation deleted successfully.")
    |> redirect(to: ~p"/moderations")
  end
end
