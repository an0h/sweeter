defmodule SweeterWeb.ItemHTML do
  use SweeterWeb, :html

  embed_templates "item_html/*"
  embed_templates "file_upload_html/*"

  @doc """
  Renders a item form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def item_form(assigns)
end