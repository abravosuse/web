defmodule Tronto.Router do
  use Commanded.Commands.Router

  alias Tronto.Monitoring.Domain.Host

  alias Tronto.Monitoring.Domain.Commands.{
    RegisterHost
  }

  identify(Host, by: :id_host)
  dispatch(RegisterHost, to: Host)
end