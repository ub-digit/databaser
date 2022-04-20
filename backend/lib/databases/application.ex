defmodule Databases.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Databases.Repo,
      # Start the Telemetry supervisor
      DatabasesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Databases.PubSub},
      # Start the Endpoint (http/https)
      Supervisor.Spec.worker(Task, [&Databases.Resource.Database.init/0], restart: :temporary),
      # Start the Endpoint (http/https)
      DatabasesWeb.Endpoint
      # Start a worker by calling: Databases.Worker.start_link(arg)
      # {Databases.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Databases.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DatabasesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
