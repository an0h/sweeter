defmodule SweeterWeb.StreetController do
  use SweeterWeb, :controller

  alias Sweeter.Cities
  alias Sweeter.Cities.Street
  # alias Sweeter.Content
  # alias Sweeter.Content.Item
  # alias Sweeter.Content.Search

  def index(conn, _params) do
    streets = Cities.list_streets()
    render(conn, :index, streets: streets)
  end

  def new(conn, _params) do
    changeset = Cities.change_street(%Street{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"street" => street_params}) do
    case Cities.create_street(street_params) do
      {:ok, street} ->
        conn
        |> put_flash(:info, "Street created successfully.")
        |> redirect(to: ~p"/streets/#{street}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    street = Cities.get_street!(id)
    render(conn, :show, street: street)
  end

  def edit(conn, %{"id" => id}) do
    street = Cities.get_street!(id)
    changeset = Cities.change_street(street)
    render(conn, :edit, street: street, changeset: changeset)
  end

  def update(conn, %{"id" => id, "street" => street_params}) do
    street = Cities.get_street!(id)

    case Cities.update_street(street, street_params) do
      {:ok, street} ->
        conn
        |> put_flash(:info, "Street updated successfully.")
        |> redirect(to: ~p"/streets/#{street}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, street: street, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    street = Cities.get_street!(id)
    {:ok, _street} = Cities.delete_street(street)

    conn
    |> put_flash(:info, "Street deleted successfully.")
    |> redirect(to: ~p"/streets")
  end
end
