defmodule Tronto.Monitoring.Domain.Commands.UpdateProviderTest do
  use ExUnit.Case

  alias Tronto.Monitoring.Domain.Commands.UpdateProvider

  @moduletag :unit

  test "should not validate if host_id is not a valid uuid" do
    command =
      UpdateProvider.new!(%{
        host_id: Faker.StarWars.character(),
        provider: Faker.StarWars.character()
      })

    assert not Vex.valid?(command)
  end
end