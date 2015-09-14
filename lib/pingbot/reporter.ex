defmodule Pingbot.Reporter do
  require Logger

  defmodule Transport.JSON do
    def transmit(dest, report) do
      report
      |> Poison.encode!
      |> http_post(dest)
    end

    defp http_post(report, dest), do: HTTPoison.post(dest, report, [{"Content-Type", "application/json"}])
  end

  @mothership Application.get_env(:pingbot, :mothership)

  def report(outcome, opts \\ [transport: Transport.JSON, dest: @mothership]) do
    outcome
    |> format_report
    |> submit_async(opts)
  end

  defp format_report({:ok, address, false}), do: %{address: address, online: false}
  defp format_report({:ok, address, time}), do: %{address: address, online: true, ms: time}
  defp format_report({:error, address, error}), do: error

  defp submit_async(report, opts) when is_map(report) do
    Task.async(opts[:transport], :transmit, [opts[:dest], report])
  end
  defp submit_async(err, _opts), do: Logger.error(err)
end
