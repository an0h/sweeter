defmodule SweeterWeb.ProfileHTML do
  use SweeterWeb, :html

  embed_templates "profile_html/*"
  embed_templates "item_list/*"
  embed_templates "file_upload_html/*"
  embed_templates "translation_html/*"

end
