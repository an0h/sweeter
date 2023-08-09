defmodule SweeterWeb.StreetHTML do
  use SweeterWeb, :html

  embed_templates "street_html/*"

  @doc """
  Renders a street form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def street_form(assigns)
end
