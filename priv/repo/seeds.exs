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

Content.create_restricted_tag(%{"label" => "Anonymous", "form_field_name" => "anonymous"})
Content.create_restricted_tag(%{"label" => "Controversial", "form_field_name" => "controversial"})
Content.create_restricted_tag(%{"label" => "Crass", "form_field_name" => "crass"})
Content.create_restricted_tag(%{"label" => "Sexually Explicit", "form_field_name" => "crass"})
Content.create_restricted_tag(%{"label" => "Violent", "form_field_name" => "violent"})

Content.create_tag(%{"label" => "News", "form_field_name" => "news"})
Content.create_tag(%{"label" => "Anecdote", "form_field_name" => "anecdote"})
Content.create_tag(%{"label" => "Poem", "form_field_name" => "poem"})
Content.create_tag(%{"label" => "Argument", "form_field_name" => "argument"})
Content.create_tag(%{"label" => "Documentation", "form_field_name" => "documentation"})
Content.create_tag(%{"label" => "Image", "form_field_name" => "image"})
Content.create_tag(%{"label" => "Joke", "form_field_name" => "joke"})
Content.create_tag(%{"label" => "Story", "form_field_name" => "story"})
Content.create_tag(%{"label" => "Thought", "form_field_name" => "thought"})
