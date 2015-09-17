defmodule Medic.Checker do
  use Medic.Recur

  alias Medic.Checks.Get
  alias Medic.Checks.Ping
  alias Medic.Reporter
  alias Medic.Storage

  def handle_cast(:tick, state) do
    Storage.list
    |> Enum.each &(Task.async(__MODULE__, :check, [&1]))

    {:noreply, state}
  end

  def check(check) do
    check
    |> perform
    |> Reporter.report
  end

  defp perform(%{type: :get} = check), do: Get.perform(check)
  defp perform(%{type: :ping} = check), do: Ping.perform(check)
end
