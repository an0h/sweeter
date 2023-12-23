defmodule SweeterWeb.ReactionComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import SweeterWeb.Gettext

  # Include the LiveComponent in your heex template
  def reactioncomponent(assigns) do
    ~H"""
    <div id="your-reaction"></div>
    <div class="reactions">
    <ul>
    <%= for reaction <- @item.reactions do %>
    <li><%= reaction.emoji %><span class="reaction-count"><%= reaction.count %></span></li>
    <% end %>
    </ul>
    </div>
    <div class="add-reactions">
    <div id="emoji-trigger">your reactions</div>
    <input type="hidden" id="item_id" value={@item.id}>
    <input type="hidden" id="address" value={@address}>
    </div>
    """
  end
end
