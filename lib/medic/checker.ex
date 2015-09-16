defmodule Medic.Checker do
  use Medic.Recur

  alias Medic.Ping
  alias Medic.Reporter
  alias Medic.Storage

  def handle_cast(:tick, state) do
    Storage.list
    |> Enum.each &(Task.async(__MODULE__, :check_ping, [&1]))

    {:noreply, state}
  end

  def check_ping(address) do
    address
    |> Ping.ping
    |> Reporter.report
  end
end
