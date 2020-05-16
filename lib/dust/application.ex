defmodule Dust.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Dust.Worker.start_link(arg)
      # {Dust.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Dust.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
