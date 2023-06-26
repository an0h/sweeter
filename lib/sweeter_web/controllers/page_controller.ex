defmodule SweeterWeb.PageController do
  use SweeterWeb, :controller

  alias Sweeter.Repo
  alias Sweeter.Content.Item

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    items = Item.get_all() |> Repo.preload(:images)
    render(conn, :home, layout: false, items: items)
  end
end
