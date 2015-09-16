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
    def transmit(_dest, report) do
      report
      |> make_string
      |> IO.puts
    end

    defp make_string(report) do
      report.address <> ": " <> outcome(report)
    end

    defp outcome(report) do
      if report.online do
         time = Float.to_string(report.ms, [decimals: 4, compact: true])
         time <> "ms"
      else
        "unavailable"
      end
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

  def report(outcome), do: GenServer.cast(__MODULE__, outcome)

  def handle_cast(outcome, opts) do
    outcome
    |> format_report
    |> submit_async(opts)

    {:noreply, opts}
  end

  defp format_report({:ok, address, false}), do: %{address: address, online: false}
  defp format_report({:ok, address, time}), do: %{address: address, online: true, ms: time}
  defp format_report({:error, _address, error}), do: error

  defp submit_async(report, opts) when is_map(report) do
    Task.async(opts[:transport], :transmit, [opts[:dest], report])
  end
  defp submit_async(err, _opts), do: Logger.error(err)
end
