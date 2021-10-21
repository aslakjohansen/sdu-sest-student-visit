defmodule GatewayApplication do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {GatewayRegistry, []},
      {Scanner, []},
    ]

    opts = [strategy: :one_for_one, name: Project.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
