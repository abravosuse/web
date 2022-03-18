defmodule Trento.Domain.Events.ClusterDetailsUpdated do
  @moduledoc """
  This event is emitted when cluster details are updated.
  """

  use TypedStruct

  alias Trento.Domain.HanaClusterDetails

  @derive Jason.Encoder
  typedstruct do
    @typedoc "ClusterDetailsUpdated event"

    field :cluster_id, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :type, :hana_scale_up | :hana_scale_out | :unknown, enforce: true
    field :sid, String.t() | nil, enforce: true
    field :details, HanaClusterDetails.t() | nil, enforce: true
  end
end