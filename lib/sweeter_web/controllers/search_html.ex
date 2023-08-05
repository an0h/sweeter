defmodule SweeterWeb.SearchHTML do
  use SweeterWeb, :html

  embed_templates "search_html/*"
  embed_templates "item_list/*"

  @doc """
  Renders a search form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def search_form(assigns)
end
