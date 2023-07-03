defmodule Sweeter.Content.TagItems do
  use Ecto.Schema

  schema "tag_items" do
    belongs_to :tag, Sweeter.Content.Tag
    belongs_to :item, Sweeter.Content.Item
    timestamps()
  end
end
