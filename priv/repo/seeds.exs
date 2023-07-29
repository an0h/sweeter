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


RestrictedTag.create_restricted_tag(%{"label" => "Anonymous", "form_field_name" => "anonymous"})
RestrictedTag.create_restricted_tag(%{"label" => "Controversial", "form_field_name" => "controversial"})
RestrictedTag.create_restricted_tag(%{"label" => "Crass", "form_field_name" => "crass"})
RestrictedTag.create_restricted_tag(%{"label" => "Sexually Explicit", "form_field_name" => "crass"})
RestrictedTag.create_restricted_tag(%{"label" => "Violent", "form_field_name" => "violent"})

Tag.create_tag(%{"label" => "News", "form_field_name" => "news"})
Tag.create_tag(%{"label" => "Anecdote", "form_field_name" => "anecdote"})
Tag.create_tag(%{"label" => "Poem", "form_field_name" => "poem"})
Tag.create_tag(%{"label" => "Argument", "form_field_name" => "argument"})
Tag.create_tag(%{"label" => "Documentation", "form_field_name" => "documentation"})
Tag.create_tag(%{"label" => "Image", "form_field_name" => "image"})
Tag.create_tag(%{"label" => "Joke", "form_field_name" => "joke"})
Tag.create_tag(%{"label" => "Story", "form_field_name" => "story"})
Tag.create_tag(%{"label" => "Thought", "form_field_name" => "thought"})
