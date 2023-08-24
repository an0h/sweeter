defmodule Sweeter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Mensia

  @impl true
  def start(_type, _args) do
    topologies = [
      sweeter_k8s: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "sweeter-epdm-svc",
          application_name: "sweeter",
          polling_interval: 10_000
        ]
      ]
    ]

    children = [
      # Start the Telemetry supervisor
      SweeterWeb.Telemetry,
      # Start the Ecto repository
      Sweeter.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sweeter.PubSub},
      # Start Finch
      {Finch, name: Sweeter.Finch},
      # Cluster Supervisor
      {Cluster.Supervisor, [topologies, [name: Sweeter.ClusterSupervisor]]},
      # Start Mnesia,
      # Pow.Store.Backend.MnesiaCache,
      {Pow.Store.Backend.MnesiaCache, extra_db_nodes: {Node, :list, []}},
      Pow.Store.Backend.MnesiaCache.Unsplit,
      # Start the Endpoint (http/https)
      SweeterWeb.Endpoint
      # Start a worker by calling: Sweeter.Worker.start_link(arg)
      # {Sweeter.Worker, arg}
    ]

    :mnesia.start
    :mnesia.create_table(
        User,
       [{:disc_copies, [node()]},
         attributes: [:address, :reaction_count, :api_count]
       ])
    :mnesia.create_table(
        Handles,
      [{:disc_copies, [node()]},
        attributes: [:user_id, :handle]
      ])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sweeter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SweeterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
