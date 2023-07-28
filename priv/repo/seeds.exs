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

alias Sweeter.Content

Content.create_tag(%{"label" => "Controversial"})
Content.create_tag(%{"label" => "Crass"})
Content.create_tag(%{"label" => "Sexually Explicit"})
Content.create_tag(%{"label" => "Violent"})

Content.create_tag(%{"label" => "News"})
Content.create_tag(%{"label" => "Anecdote"})
Content.create_tag(%{"label" => "Poem"})
Content.create_tag(%{"label" => "Argument"})
Content.create_tag(%{"label" => "Documentation"})
Content.create_tag(%{"label" => "Image"})
Content.create_tag(%{"label" => "Joke"})
Content.create_tag(%{"label" => "Story"})
Content.create_tag(%{"label" => "Thought"})
