defmodule Medic.Reporter do
  @moduledoc """
  Report health check results.
  """
  use GenServer

  require Logger

  @defaults [transport: Medic.Reporter.JSON]

  defmodule JSON do
    @moduledoc """
    Report the results via an JSON API request
    """

    @doc """
    Transmit report as JSON via HTTP to destination
    """
    def transmit(dest, report) do
      %{"report" => report}
      |> Poison.encode!
      |> http_post(dest)
    end

    @doc false
    defp auth_token, do: Application.get_env(:medic, :auth_token)

    @doc false
    defp http_post(report, dest) do
      HTTPoison.post!(dest, report, http_headers)
    end

    @doc false
    defp http_headers do
      [
        {"Content-Type", "application/json"},
        {"Authorization", "Bearer " <> auth_token}
      ]
    end
  end

  defmodule Inbox do
    @moduledoc """
    Using the OTP mailbox to submit report.
    """

    @doc """
    Use Kernel.send to transmit report
    """
    def transmit(dest, report), do: send(dest, report)
  end

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
  def init(opts), do: {:ok, Keyword.merge(@defaults, opts)}

  @doc """
  Submit a given report.
  """
  def report(report), do: GenServer.cast(__MODULE__, report)

  ### Service API

  @doc false
  def handle_cast(report, opts) do
    Task.start(opts[:transport], :transmit, [opts[:dest], report])
    {:noreply, opts}
  end
end
