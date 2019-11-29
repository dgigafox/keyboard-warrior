# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :keyboard_warrior,
  ecto_repos: [KeyboardWarrior.Repo]

# Configures the endpoint
config :keyboard_warrior, KeyboardWarriorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z4PwQu+CNQvv37uiFchh6MCV+H5NNMwzYstjSYlNKhX/u8XHcFqU9emRNciZoUtK",
  render_errors: [view: KeyboardWarriorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KeyboardWarrior.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "JpQHs5VV2a6XZ9g7icy2qU5eQSB79Mk/"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures enablement of LiveView templates
config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
