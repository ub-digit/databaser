defmodule DbListAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    # initialize all indexes

    children = [
      # Start the Ecto repository
      DbListAdmin.Repo,
      # Start the Telemetry supervisor
      DbListAdminWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DbListAdmin.PubSub},
      # Start the Endpoint (http/https)
      DbListAdminWeb.Endpoint,
      # Start a worker by calling: DbListAdmin.Worker.start_link(arg)
      DbListAdmin.Resource.Elastic.Index
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DbListAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DbListAdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
