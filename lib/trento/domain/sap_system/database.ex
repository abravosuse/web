defmodule Trento.Domain.SapSystem.Database do
  @moduledoc """
  This module represents a SAP System database.
  """

  alias Trento.Domain.SapSystem.Instance

  @required_fields []

  use Trento.Type

  deftype do
    field :sid, :string
    embeds_many :instances, Instance
    field :health, Ecto.Enum, values: [:passing, :warning, :critical, :unknown]
  end
end
