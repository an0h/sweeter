defmodule SweeterWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  use SweeterWeb, :verified_routes

  @impl true
  def after_registration_path(_conn), do: ~p"/session/new"
end
