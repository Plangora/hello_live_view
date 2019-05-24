# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello_live_view,
  ecto_repos: [HelloLiveView.Repo]

# Configures the endpoint
config :hello_live_view, HelloLiveViewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3nFITOb9g/ZF69If/iIdAGNSNkbWarl9u0+X45aMfPjFn4Sg6LYyEVGF92bN/amM",
  render_errors: [view: HelloLiveViewWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HelloLiveView.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "nuZn/1owO6mDMJ4/iZSq6YYS4cGb/cT8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
