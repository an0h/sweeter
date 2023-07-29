defmodule SweeterWeb.API.V1.APIJSON do
  alias Sweeter.Content.Item
  alias Sweeter.Content.Tag
  alias Sweeter.Content.RestrictedTag

  def items(%{items: items}) do
    %{data: for(item <- items, do: itemize(item))}
  end

  def item(%{item: item}) do
    %{item: itemize(item)}
  end

  def slugs(%{tags: tags}) do
    %{slugs: for(tag <- tags, do: get_slug(tag))}
  end

  defp get_slug(%Tag{} = tag) do
    tag.slug
  end

  defp get_slug(%RestrictedTag{} = tag) do
    tag.slug
  end

  defp itemize(%Item{} = item) do
    %{
      id: item.id,
      headline: item.headline,
      body: item.body,
      source: item.source,
      tags: Tag.get_tag_labels_for_item(item.id),
      tag_slugs: Tag.get_tag_slugs_for_item(item.id),
      restricted_tags: RestrictedTag.get_restricted_tag_labels_for_item(item.id),
      restricted_tag_slugs: RestrictedTag.get_restricted_tag_slugs_for_item(item.id)
    }
  end

end
