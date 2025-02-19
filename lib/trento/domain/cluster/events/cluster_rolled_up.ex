defmodule Trento.Domain.Events.ClusterRolledUp do
  @moduledoc """
  This event is emitted when a cluster is rolled up and its stream is reset.
  """

  use Trento.Event

  require Trento.Domain.Enums.Provider, as: Provider
  require Trento.Domain.Enums.ClusterType, as: ClusterType
  require Trento.Domain.Enums.Health, as: Health

  alias Trento.Domain.{
    HanaClusterDetails,
    HostExecution
  }

  defevent do
    field :cluster_id, :string
    field :name, :string
    field :type, Ecto.Enum, values: ClusterType.values()
    field :sid, :string
    field :provider, Ecto.Enum, values: Provider.values()
    field :resources_number, :integer
    field :hosts_number, :integer
    field :health, Ecto.Enum, values: Health.values()
    field :hosts, {:array, :string}
    field :selected_checks, {:array, :string}
    field :discovered_health, Ecto.Enum, values: Health.values()
    field :checks_health, Ecto.Enum, values: Health.values()

    embeds_one :details, HanaClusterDetails
    embeds_many :hosts_executions, HostExecution

    field :applied, :boolean, default: false
  end
end
