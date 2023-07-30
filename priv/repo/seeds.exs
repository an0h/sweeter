# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sweeter.Repo.insert!(%Sweeter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Sweeter.Content.Tag
alias Sweeter.Content.RestrictedTag


RestrictedTag.create_restricted_tag(%{"label" => "Anonymous", "slug" => "anonymous"})
RestrictedTag.create_restricted_tag(%{"label" => "Controversial", "slug" => "controversial"})
RestrictedTag.create_restricted_tag(%{"label" => "Crass", "slug" => "crass"})
RestrictedTag.create_restricted_tag(%{"label" => "Sexually Explicit", "slug" => "sexually_explicit"})
RestrictedTag.create_restricted_tag(%{"label" => "Violent", "slug" => "violent"})

Tag.create_tag(%{"label" => "Anecdote", "slug" => "anecdote"})
Tag.create_tag(%{"label" => "Argument", "slug" => "argument"})
Tag.create_tag(%{"label" => "Documentation", "slug" => "documentation"})
Tag.create_tag(%{"label" => "Image", "slug" => "image"})
Tag.create_tag(%{"label" => "Information", "slug" => "information"})
Tag.create_tag(%{"label" => "Joke", "slug" => "joke"})
Tag.create_tag(%{"label" => "News", "slug" => "news"})
Tag.create_tag(%{"label" => "Poem", "slug" => "poem"})
Tag.create_tag(%{"label" => "Story", "slug" => "story"})
Tag.create_tag(%{"label" => "Thought", "slug" => "thought"})
