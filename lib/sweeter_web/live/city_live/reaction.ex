defmodule ReactionsComponent do
  use SweeterWeb, :live_component
  alias Sweeter.Content.Reactions

  @impl true
  def render(assigns) do
    ~H"""
    <div class="reactions">😇😈<%= @content %></div>
    """
  end

  # @impl true
  # def mount(_params, _session, socket) do
  #   reactions = Reactions.get_reactions_for_item(1)
  #   {:ok, stream(socket, :reactions, reactions)}
  # end

  # @impl true
  # def handle_params(%{"id" => id}, _, socket) do
  #   IO.inspect id
  #   IO.puts "what is the id"
  #   {:noreply,
  #    socket
  #    |> assign(:reactions, Reactions.get_reactions_for_item(1))}
  # end
end
