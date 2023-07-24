defmodule SweeterWeb.ModerationHTML do
  use SweeterWeb, :html

  embed_templates "moderation_html/*"

  @doc """
  Renders a moderation form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def moderation_form(assigns)
end
