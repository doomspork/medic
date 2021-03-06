defmodule Medic.Checker do
  @moduledoc """
  Execute our list of health checks on a recurring basis
  """
  use Medic.Recur

  require Logger

  alias Medic.Checks.Get
  alias Medic.Checks.Ping
  alias Medic.Report
  alias Medic.Reporter
  alias Medic.Storage

  def handle_cast(:tick, state) do
    Storage.list
    |> Enum.each &(Task.async(__MODULE__, :check, [&1]))

    {:noreply, state}
  end

  @doc """
  Perform the provided check and submit the report.
  """
  def check(check) do
    check
    |> perform
    |> apply_timestamp
    |> Reporter.report
  end

  defp apply_timestamp(report) do
    timestamp = :calendar.universal_time
                |> :calendar.datetime_to_gregorian_seconds

    %Report{report | time: timestamp}
  end

  defp perform(%{type: "get"} = check), do: Get.perform(check)
  defp perform(%{type: "ping"} = check), do: Ping.perform(check)
  defp perform(%{type: type}), do: Logger.error("Unknown type: #{type}")
end
