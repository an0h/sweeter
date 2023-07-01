defmodule ReactionsComponent do
  use SweeterWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="reactions">😇😈<%= @content %></div>
    """
  end
end
