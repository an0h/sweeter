defmodule SweeterWeb.ReactionComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import SweeterWeb.Gettext

  # Include the LiveComponent in your heex template
  def reactioncomponent(assigns) do
    ~L"""
    <div>
    the render of reactioncomponents
    </div>
    """
  end
end
