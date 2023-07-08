defmodule SweeterWeb.CoolerChannel do
  use SweeterWeb, :channel

  alias Sweeter.Content.Reactions
  alias Sweeter.CreditDebit

  @impl true
  def join("cooler:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (cooler:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (cooler:lobby).
  @impl true
  def handle_in("react", payload, socket) do
    # user = current_resource(socket)
    # IO.puts("user handle_in react")
    # {:error, newsocketoldsocket} = current_user(socket)
    broadcast(socket, "react", payload)
    %{"item_id" => item_id, "emoji" => emoji, "description" => description, "address" => address} = payload
    IO.inspect address
    Reactions.create_item_reaction(%{emoji: emoji, description: description}, item_id)
    CreditDebit.increment_interaction(address)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  # defp current_user(socket) do
  #   token = %{}
  #   case Guardian.Phoenix.Socket.authenticate(socket, Sweeter.Guardian, token) do
  #     {:ok, authed_socket} ->
  #       {:ok, authed_socket}
  #     {:error, _} -> :error
  #   end
  # end
  # defp current_user(socket) do
  #   case Guardian.Plug.current_resource(socket) do
  #     {:ok, user} ->
  #       IO.inspect user
  #       {:ok, assign(socket, :user, user), user}
  #     e ->
  #       IO.inspect(e)
  #       {:error, %{reason: "unauthorized"}}
  #   end
  # end
end
