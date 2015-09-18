defmodule Medic.Reporter do
  @moduledoc """
  Report health check results.
  """

  use GenServer
  require Logger

  defmodule JSON do
    @moduledoc """
    Report the results via an JSON API request
    """

    def transmit(dest, report) do
      report
      |> Poison.encode!
      |> http_post(dest)
    end

    defp http_post(report, dest) do
      HTTPoison.post(dest, report, [{"Content-Type", "application/json"}])
    end
  end

  defmodule StdOut do
    @moduledoc """
    Format and print the report to standard out.
    """

    def transmit(_dest, %{address: address, check_id: id, results: %{time: time}}) do
      IO.puts "#{address} (#{id}): #{time}ms"
    end
  end

  defmodule Inbox do
    @moduledoc """
    Using the OTP mailbox to submit report.
    """

    def transmit(dest, report), do: send(dest, report)
  end

  @defaults [transport: StdOut]

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

  def handle_cast(report, opts) do
    Task.async(opts[:transport], :transmit, [opts[:dest], report])

    {:noreply, opts}
  end
end
