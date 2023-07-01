defmodule ReactionsComponent do
  use SweeterWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="reaction">😇😈<%= @content %></div>
    """
  end
end
