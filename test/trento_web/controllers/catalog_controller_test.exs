defmodule TrentoWeb.CatalogControllerTest do
  use TrentoWeb.ConnCase, async: true

  import Mox

  alias Trento.Integration.Checks.FlatCatalogDto

  @runner_fixtures_path File.cwd!() <> "/test/fixtures/runner"

  def load_runner_fixture(name) do
    @runner_fixtures_path
    |> Path.join("#{name}.json")
    |> File.read!()
    |> Jason.decode!()
  end

  test "should return a catalog grouped by providers", %{conn: conn} do
    raw_catalog = load_runner_fixture("catalog")

    Trento.Integration.Checks.Mock
    |> expect(:get_catalog, fn -> FlatCatalogDto.new(%{checks: raw_catalog}) end)

    conn = get(conn, Routes.catalog_path(conn, :checks_catalog))

    expected_json = [
      %{
        "groups" => [
          %{
            "checks" => [
              %{
                "description" => "description 1",
                "id" => "1",
                "implementation" => "implementation 1",
                "labels" => "labels",
                "name" => "test 1",
                "remediation" => "remediation 1",
                "premium" => true
              },
              %{
                "description" => "description 2",
                "id" => "2",
                "implementation" => "implementation 2",
                "labels" => "labels",
                "name" => "test 2",
                "remediation" => "remediation 2",
                "premium" => false
              }
            ],
            "group" => "Group 1"
          },
          %{
            "checks" => [
              %{
                "description" => "description 3",
                "id" => "3",
                "implementation" => "implementation 3",
                "labels" => "labels",
                "name" => "test 3",
                "remediation" => "remediation 3",
                "premium" => false
              },
              %{
                "description" => "description 4",
                "id" => "4",
                "implementation" => "implementation 4",
                "labels" => "labels",
                "name" => "test 4",
                "remediation" => "remediation 4",
                "premium" => false
              }
            ],
            "group" => "Group 2"
          },
          %{
            "checks" => [
              %{
                "description" => "description 5",
                "id" => "5",
                "implementation" => "implementation 5",
                "labels" => "labels",
                "name" => "test 5",
                "remediation" => "remediation 5",
                "premium" => false
              }
            ],
            "group" => "Group 3"
          }
        ],
        "provider" => "aws"
      },
      %{
        "groups" => [
          %{
            "checks" => [
              %{
                "description" => "description 1",
                "id" => "1",
                "implementation" => "implementation 1",
                "labels" => "labels",
                "name" => "test 1",
                "remediation" => "remediation 1",
                "premium" => true
              },
              %{
                "description" => "description 2",
                "id" => "2",
                "implementation" => "implementation 2",
                "labels" => "labels",
                "name" => "test 2",
                "remediation" => "remediation 2",
                "premium" => false
              }
            ],
            "group" => "Group 1"
          },
          %{
            "checks" => [
              %{
                "description" => "description 3",
                "id" => "3",
                "implementation" => "implementation 3",
                "labels" => "labels",
                "name" => "test 3",
                "remediation" => "remediation 3",
                "premium" => false
              },
              %{
                "description" => "description 4",
                "id" => "4",
                "implementation" => "implementation 4",
                "labels" => "labels",
                "name" => "test 4",
                "remediation" => "remediation 4",
                "premium" => false
              }
            ],
            "group" => "Group 2"
          },
          %{
            "checks" => [
              %{
                "description" => "description 5",
                "id" => "5",
                "implementation" => "implementation 5",
                "labels" => "labels",
                "name" => "test 5",
                "remediation" => "remediation 5",
                "premium" => false
              }
            ],
            "group" => "Group 3"
          }
        ],
        "provider" => "azure"
      },
      %{
        "groups" => [
          %{
            "checks" => [
              %{
                "description" => "description default 1",
                "id" => "1",
                "implementation" => "implementation default 1",
                "labels" => "labels",
                "name" => "test default 1",
                "remediation" => "remediation default 1",
                "premium" => false
              }
            ],
            "group" => "Group default 1"
          }
        ],
        "provider" => "default"
      }
    ]

    assert expected_json == json_response(conn, 200)
  end

  test "should return a filtered flat catalog", %{conn: conn} do
    raw_catalog = load_runner_fixture("catalog")

    Trento.Integration.Checks.Mock
    |> expect(:get_catalog, fn -> FlatCatalogDto.new(%{checks: raw_catalog}) end)

    conn =
      get(conn, Routes.catalog_path(conn, :checks_catalog), %{
        "flat" => "",
        "provider" => "azure"
      })

    expected_json = [
      %{
        "provider" => "azure",
        "description" => "description 1",
        "group" => "Group 1",
        "id" => "1",
        "implementation" => "implementation 1",
        "labels" => "labels",
        "name" => "test 1",
        "remediation" => "remediation 1",
        "premium" => true
      },
      %{
        "provider" => "azure",
        "description" => "description 2",
        "group" => "Group 1",
        "id" => "2",
        "implementation" => "implementation 2",
        "labels" => "labels",
        "name" => "test 2",
        "remediation" => "remediation 2",
        "premium" => false
      },
      %{
        "description" => "description 3",
        "group" => "Group 2",
        "id" => "3",
        "implementation" => "implementation 3",
        "labels" => "labels",
        "name" => "test 3",
        "provider" => "azure",
        "remediation" => "remediation 3",
        "premium" => false
      },
      %{
        "description" => "description 4",
        "group" => "Group 2",
        "id" => "4",
        "implementation" => "implementation 4",
        "labels" => "labels",
        "name" => "test 4",
        "provider" => "azure",
        "remediation" => "remediation 4",
        "premium" => false
      },
      %{
        "description" => "description 5",
        "group" => "Group 3",
        "id" => "5",
        "implementation" => "implementation 5",
        "labels" => "labels",
        "name" => "test 5",
        "provider" => "azure",
        "remediation" => "remediation 5",
        "premium" => false
      }
    ]

    assert expected_json == json_response(conn, 200)
  end

  test "should return a default flat catalog when unknown provider is used", %{conn: conn} do
    raw_catalog = load_runner_fixture("catalog")

    Trento.Integration.Checks.Mock
    |> expect(:get_catalog, fn -> FlatCatalogDto.new(%{checks: raw_catalog}) end)

    conn =
      get(conn, Routes.catalog_path(conn, :checks_catalog), %{
        "flat" => "",
        "provider" => "unknown"
      })

    expected_json = [
      %{
        "provider" => "default",
        "description" => "description default 1",
        "group" => "Group default 1",
        "id" => "1",
        "implementation" => "implementation default 1",
        "labels" => "labels",
        "name" => "test default 1",
        "remediation" => "remediation default 1",
        "premium" => false
      }
    ]

    assert expected_json == json_response(conn, 200)
  end

  test "should return a flat catalog", %{conn: conn} do
    raw_catalog = load_runner_fixture("catalog")

    Trento.Integration.Checks.Mock
    |> expect(:get_catalog, fn -> FlatCatalogDto.new(%{checks: raw_catalog}) end)

    conn =
      get(conn, Routes.catalog_path(conn, :checks_catalog), %{
        "flat" => ""
      })

    expected_json = [
      %{
        "provider" => "azure",
        "description" => "description 1",
        "group" => "Group 1",
        "id" => "1",
        "implementation" => "implementation 1",
        "labels" => "labels",
        "name" => "test 1",
        "remediation" => "remediation 1",
        "premium" => true
      },
      %{
        "provider" => "azure",
        "description" => "description 2",
        "group" => "Group 1",
        "id" => "2",
        "implementation" => "implementation 2",
        "labels" => "labels",
        "name" => "test 2",
        "remediation" => "remediation 2",
        "premium" => false
      },
      %{
        "description" => "description 3",
        "group" => "Group 2",
        "id" => "3",
        "implementation" => "implementation 3",
        "labels" => "labels",
        "name" => "test 3",
        "provider" => "azure",
        "remediation" => "remediation 3",
        "premium" => false
      },
      %{
        "description" => "description 4",
        "group" => "Group 2",
        "id" => "4",
        "implementation" => "implementation 4",
        "labels" => "labels",
        "name" => "test 4",
        "provider" => "azure",
        "remediation" => "remediation 4",
        "premium" => false
      },
      %{
        "description" => "description 5",
        "group" => "Group 3",
        "id" => "5",
        "implementation" => "implementation 5",
        "labels" => "labels",
        "name" => "test 5",
        "provider" => "azure",
        "remediation" => "remediation 5",
        "premium" => false
      },
      %{
        "description" => "description 1",
        "group" => "Group 1",
        "id" => "1",
        "implementation" => "implementation 1",
        "labels" => "labels",
        "name" => "test 1",
        "provider" => "aws",
        "remediation" => "remediation 1",
        "premium" => true
      },
      %{
        "description" => "description 2",
        "group" => "Group 1",
        "id" => "2",
        "implementation" => "implementation 2",
        "labels" => "labels",
        "name" => "test 2",
        "provider" => "aws",
        "remediation" => "remediation 2",
        "premium" => false
      },
      %{
        "description" => "description 3",
        "group" => "Group 2",
        "id" => "3",
        "implementation" => "implementation 3",
        "labels" => "labels",
        "name" => "test 3",
        "provider" => "aws",
        "remediation" => "remediation 3",
        "premium" => false
      },
      %{
        "description" => "description 4",
        "group" => "Group 2",
        "id" => "4",
        "implementation" => "implementation 4",
        "labels" => "labels",
        "name" => "test 4",
        "provider" => "aws",
        "remediation" => "remediation 4",
        "premium" => false
      },
      %{
        "description" => "description 5",
        "group" => "Group 3",
        "id" => "5",
        "implementation" => "implementation 5",
        "labels" => "labels",
        "name" => "test 5",
        "provider" => "aws",
        "remediation" => "remediation 5",
        "premium" => false
      },
      %{
        "provider" => "default",
        "description" => "description default 1",
        "group" => "Group default 1",
        "id" => "1",
        "implementation" => "implementation default 1",
        "labels" => "labels",
        "name" => "test default 1",
        "remediation" => "remediation default 1",
        "premium" => false
      }
    ]

    assert expected_json == json_response(conn, 200)
  end
end
