defmodule Medic.Reporter do
  @moduledoc """
  Report health check results.
  """
  use GenServer

  require Logger

  @auth_token Application.get_env(:medic, :auth_token)

  ### Client API

  @doc """
  Start our Reporter and link it.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Initialize our GenServer.
  """
  def init(opts), do: {:ok, opts}

  @doc """
  Submit a given report.
  """
  def report(report), do: GenServer.cast(__MODULE__, report)

  ### Service API

  @doc false
  def handle_cast(report, opts) do
    %{"report" => report}
    |> Poison.encode!
    |> http_post(opts[:dest])

    {:noreply, opts}
  end

  @doc false
  defp http_post(report, dest) do
    HTTPoison.post!(dest, report, http_headers)
  end

  @doc false
  defp http_headers do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer " <> @auth_token}
    ]
  end

end
