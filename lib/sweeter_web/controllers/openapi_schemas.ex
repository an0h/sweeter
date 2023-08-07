defmodule SweeterWeb.API.V1.Schemas do
  alias OpenApiSpex.Schema

  defmodule ItemList do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ItemList",
      description: "Response schema for item list",
      type: :object,
      properties: %{
        body: %Schema{type: :string, description: "body text"},
        headline: %Schema{type: :string, description: "headline"},
        id: %Schema{type: :integer, description: "primary key id"},
        page_views: %Schema{type: :integer, description: "number of page loads in browser", format: :date},
        # restricted_tag_slugs: [%Schema{type: :string,description: "snake_case slugs"}],
        # restricted_tags: [%Schema{type: :string,description: "pretty, human readable tags"}],
        source: %Schema{type: :string, description: "item source", format: :date}
        # tag_slugs: [%Schema{type: :string,description: "snake_case slugs"}],
        # tags: [%Schema{type: :string,description: "pretty, human readable tags"}]
      },
      example: %{
        "data" => [%{
          "body" => "body text",
          "headline" => "headdddline",
          "id" => 1,
          "page_views" => 83,
          "restricted_tag_slugs" => [],
          "restricted_tags" => [],
          "source" => nil,
          "tag_slugs" => [],
          "tags" => []
        },
        %{
          "body" => "body text",
          "headline" => "headdddline",
          "id" => 1,
          "page_views" => 83,
          "restricted_tag_slugs" => [],
          "restricted_tags" => [],
          "source" => nil,
          "tag_slugs" => [],
          "tags" => []
        }
      ]
      }
    })
  end
end
