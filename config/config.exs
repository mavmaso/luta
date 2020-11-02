# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :luta,
  ecto_repos: [Luta.Repo]

# Configures the endpoint
config :luta, LutaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VOp9oWtmSH8tsWeDtU6UrEqW4e3rB3E4fJZoWq8+TeIG910Tj185ZzA2h9jsRbEQ",
  render_errors: [view: LutaWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Luta.PubSub,
  live_view: [signing_salt: "yE0Z4HoK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
config :luta, Luta.Guardian,
  issuer: "luta",
  secret_key: "4gsDn2iJL+IiY/TUJBAh2FrjD+jZQANlKdv+e+WlMHd4kK0hhORMXFG7jeSGOPE9"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
