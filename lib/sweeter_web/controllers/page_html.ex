defmodule SweeterWeb.PageHTML do
  use SweeterWeb, :html

  embed_templates "page_html/*"
  embed_templates "item_list/*"
  embed_templates "translation_html/*"
end
