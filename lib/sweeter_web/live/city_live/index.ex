defmodule SweeterWeb.CityLive.Index do
  use SweeterWeb, :live_view

  alias Sweeter.Content
  alias Sweeter.Content.City
  alias Sweeter.Content.Item

  @impl true
  def mount(_params, _session, socket) do
    items = Item.get_all()
    {:ok, stream(socket, :items, Item.get_all())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit City")
    |> assign(:city, Content.get_city!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New City")
    |> assign(:city, %City{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cities")
    |> assign(:city, nil)
  end

  @impl true
  def handle_info({SweeterWeb.CityLive.FormComponent, {:saved, city}}, socket) do
    {:noreply, stream_insert(socket, :cities, city)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    city = Content.get_city!(id)
    {:ok, _} = Content.delete_city(city)

    {:noreply, stream_delete(socket, :cities, city)}
  end
end
