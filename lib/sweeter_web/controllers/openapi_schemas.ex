defmodule SweeterWeb.API.V1.Schemas do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  defmodule TagSchema do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Tag",
      description: "Tag",
      type: :object,
      properties: %{
        label: %Schema{type: :string, description: "human readable"},
        slug: %Schema{type: :string, description: "stripped and snake cased"}
      },
      example: %{
        "label" => "some ! text",
        "slug" => "some_text",
        "id" => 1
      }
    })
  end

  defmodule RestrictedTagSchema do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "RestrictedTag",
      description: "RestrictedTag",
      type: :object,
      properties: %{
        label: %Schema{type: :string, description: "human readable"},
        slug: %Schema{type: :string, description: "stripped and snake cased"}
      },
      example: %{
        "label" => "Sexually Explicit",
        "slug" => "sexually_explicit",
        "id" => 1
      }
    })
  end

  defmodule ItemSchema do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ItemSchema",
      description: "Item",
      type: :object,
      properties: %{
        body: %Schema{type: :string, description: "body text"},
        headline: %Schema{type: :string, description: "headline"},
        id: %Schema{type: :integer, description: "primary key id"},
        page_views: %Schema{type: :integer, description: "number of page loads in browser", format: :date},
        restricted_tag_slugs: %Schema{type: :list, description: "snake_case slugs"},
        restricted_tags: %Schema{type: :list, description: "pretty, human readable tags"},
        source: %Schema{type: :string, description: "item source", format: :date},
        tag_slugs: %Schema{type: :list, description: "snake_case slugs"},
        tags: %Schema{type: :list, description: "pretty, human readable tags"}
      },
      example: %{
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
    })
  end

  defmodule ItemList do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ItemList",
      description: "Response schema for item list",
      type: :object,
      properties: %{
        data: %Schema{type: :list, description: "list of items"}
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

  defmodule SlugList do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SlugList",
      description: "list of slugs for tags",
      type: :object,
      properties: %{
        data: %Schema{type: :list, description: "list of snake case slugs"}
      },
      example: %{
        "slugs": [
            "anecdote",
            "argument",
            "documentation",
            "image",
            "information",
            "joke",
            "news",
            "poem",
            "story",
            "thought"
        ]
      }
    })
  end

  defmodule RestrictedSlugList do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "RestrictedSlugList",
      description: "list of slugs for restricted tags",
      type: :object,
      properties: %{
        data: %Schema{type: :list, description: "list of snake case slugs"}
      },
      example: %{
        "slugs": [
          "anonymous",
          "controversial",
          "crass",
          "sexually_explicit",
          "violent"
        ]
      }
    })
  end
end
