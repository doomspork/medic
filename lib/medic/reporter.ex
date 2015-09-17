defmodule Medic.Reporter do
  use GenServer
  require Logger

  defmodule JSON do
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
    def transmit(_dest, %{address: address, check_id: id, results: %{time: time}}) do
      "#{address} (#{id}): #{time}ms"
      |> IO.puts
    end
  end

  defmodule Inbox do
    def transmit(dest, report), do: send(dest, report)
  end

  @defaults [transport: StdOut]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts), do: {:ok, Keyword.merge(@defaults, opts)}

  def report(report), do: GenServer.cast(__MODULE__, report)

  def handle_cast(report, opts) do
    Task.async(opts[:transport], :transmit, [opts[:dest], report])

    {:noreply, opts}
  end
end
