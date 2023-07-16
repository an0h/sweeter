defmodule SweeterWeb.ReactionComponents do
  use Phoenix.LiveComponent

  # Include the picmo library in your JavaScript assets
  def mount(%{root: _root} = _params, _session, socket) do
    {:ok, socket}
  end

  # Include the LiveComponent in your heex template
  def render(assigns) do
    ~L"""
    <div>
    the render of reactioncomponents
    </div>
    """
  end
end
