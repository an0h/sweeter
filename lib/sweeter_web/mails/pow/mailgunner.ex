defmodule SweeterWeb.Pow.Mailgunner do
  use Swoosh.Mailer, otp_app: :sweeter
  import Swoosh.Email

  def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
    # Build email struct to be used in `process/1`

    %{to: user.email, subject: subject, text: text, html: html}
  end

  def process(email) do
    # Send email
    Logger.debug("MAILGUN E-mail sent: #{inspect email}")

    new()
    |> from({"an0h", "an0h@decisived.com"})
    |> to(email.to)
    |> subject("Sign up confirmation for interenetstate.city")
    |> html_body(email.html)
    |> text_body(email.text)
  end
end
