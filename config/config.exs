# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sweeter,
  ecto_repos: [Sweeter.Repo]

# Configures the endpoint
config :sweeter, SweeterWeb.Endpoint,
  url: [host: "0.0.0.0:4000"],
  check_origin: ["//0.0.0.0:4000", "//localhost:4000", "//sweeter:4000", "//0.0.0.0", "//localhost", "//sweeter"],
  render_errors: [
    formats: [html: SweeterWeb.ErrorHTML, json: SweeterWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Sweeter.PubSub,
  live_view: [signing_salt: "YNCNoZBN"]

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
      ~w(js/app.js js/scripts.js js/litepicker.js js/markdown.js js/toasts.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure dart_sass
config :dart_sass,
  version: "1.58.0",
  default: [
    args: ~w(css/app.css ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Sweeter",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "NZ1dKSZSjB45GYkPGSmWgBQoNtTFnP9pS13TeIzYZ6EqvNokTJf5DFXfIOXzc1M7",
  serializer: Guardian.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
