# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sweeter,
  ecto_repos: [Sweeter.Repo],
  api1317: "http://10.104.0.13:1317",
  faucet4500: "http://10.104.0.13:4500",
  assigner5555: "http://10.104.0.13:5555"

# Configures the endpoint
config :sweeter, SweeterWeb.Endpoint,
  url: [host: "0.0.0.0"],
  check_origin: ["//0.0.0.0:4000", "//localhost:4000", "//sweeter:4000", "//0.0.0.0", "//localhost", "//sweeter", "//cherry.internetstate.city"],
  render_errors: [
    formats: [html: SweeterWeb.ErrorHTML, json: SweeterWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Sweeter.PubSub,
  live_view: [signing_salt: "lKVJ4STY"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :sweeter, Sweeter.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :sweeter, :pow,
  web_mailer_module: SweeterWeb,
  web_module: SweeterWeb,
  user: Sweeter.Users.User,
  repo: Sweeter.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: SweeterWeb.Pow.Mailer

config :sweeter, SweeterWeb.Pow.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: "",
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]
# config :sweeter, SweeterWeb.Pow.Mailer,
#   adapter: Bamboo.MailgunAdapter,
#   hackney_opts: [
#     recv_timeout: :timer.minutes(1)
#   ]
  # sory please dont take my keys
config :swoosh, api_client: Swoosh.ApiClient.Sweeter, sweeter: SweeterWeb.Pow.Mailer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
