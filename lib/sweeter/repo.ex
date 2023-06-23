defmodule Sweeter.Repo do
  use Ecto.Repo,
    otp_app: :sweeter,
    adapter: Ecto.Adapters.Postgres
end
