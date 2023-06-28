defmodule Sweeter.GuardianSerializer do
  @behaviour Sweeter.People.Guardian.Serializer

  alias Sweeter.Repo
  alias Sweeter.People.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
