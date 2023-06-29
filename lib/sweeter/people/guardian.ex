defmodule Sweeter.People.Guardian do
  use Guardian, otp_app: :sweeter

  alias Sweeter.People

  def subject_for_token(user, _claims) do
    user_id = to_string(user.id)
    IO.inspect("is this subject thing called")
    {:ok, user_id}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    try do
      person = People.get_user!(id)
      {:ok, person}
    rescue
      _e ->
        IO.puts("no claims for user, user not logged in?")
        {:error, :user_not_found}
    end
  end
end
