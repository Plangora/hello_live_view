defmodule HelloLiveView.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Cachex.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      HelloLiveView.Repo,
      HelloLiveViewWeb.Telemetry,
      # Start the endpoint when the application starts
      HelloLiveViewWeb.Endpoint,
      # Starts a worker by calling: HelloLiveView.Worker.start_link(arg)
      HelloLiveViewWeb.Presence,
      Supervisor.Spec.worker(Cachex, [
        :user_cache,
        [expiration: expiration(default: :timer.hours(1), interval: :timer.hours(1))]
      ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloLiveView.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HelloLiveViewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
