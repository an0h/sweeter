defmodule SweeterWeb.ReactionsChannel do
  use SweeterWeb, :channel

  alias Sweeter.Content.Reactions

  @impl true
  def join("reactions:lobby", payload, socket) do
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
  # broadcast to everyone in the current topic (reactions:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (cooler:lobby).
  @impl true
  def handle_in("react", payload, socket) do
    IO.inspect("got to the reaction handle in")
    # user = current_resource(socket)
    # IO.puts("user handle_in react")
    # {:error, newsocketoldsocket} = current_user(socket)
    broadcast(socket, "react", payload)
    %{"item_id" => item_id, "emoji" => emoji, "description" => description} = payload
    # IO.inspect address
    response = Reactions.create_item_reaction(%{emoji: emoji, description: description}, item_id)
    IO.inspect response
    # CreditDebit.increment_interaction(address)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
