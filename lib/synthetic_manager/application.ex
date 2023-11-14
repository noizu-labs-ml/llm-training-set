defmodule SyntheticManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SyntheticManagerWeb.Telemetry,
      SyntheticManager.Repo,
      {DNSCluster, query: Application.get_env(:synthetic_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SyntheticManager.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SyntheticManager.Finch},
      # Start a worker by calling: SyntheticManager.Worker.start_link(arg)
      # {SyntheticManager.Worker, arg},
      # Start to serve requests, typically the last entry
      SyntheticManagerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SyntheticManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SyntheticManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
