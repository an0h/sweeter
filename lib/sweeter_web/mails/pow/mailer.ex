defmodule SweeterWeb.Pow.Mailer do
  use Pow.Phoenix.Mailer
  use Swoosh.Mailer, otp_app: :sweeter

  import Swoosh.Email

  require Logger

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new()
    |> to({"", user.email})
    |> from({"internetstate.city", "anoh@decisived.com"})
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  @impl true
  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.

    IO.puts "this is in mailgunner"
    IO.inspect email

    Task.start(fn ->
      email
      |> deliver()
      |> log_warnings()
    end)

    :ok
  end

  defp log_warnings({:error, reason}) do
    Logger.warn("Mailer backend failed with: #{inspect(reason)}")
  end

  defp log_warnings({:ok, response}), do: {:ok, response}
end
