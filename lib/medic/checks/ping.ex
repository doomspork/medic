defmodule Medic.Checks.Ping do
  @moduledoc """
  Uses `ping` to report on availability and response time.
  """

  alias Medic.Report

  @doc """
  Perform the given %Check{} and return an appropriate %Report{}.
  """
  def perform(%{address: address, id: id}) do
    time = try do
             {cmd_output, _} = System.cmd("ping", ping_args(address))
             parse_output(cmd_output)
           rescue
             _e -> nil
           end

    %Report{address: address, check_id: id, results: %{time: time}}
  end

  defp darwin? do
    {output, 0} = System.cmd("uname", [])
    String.rstrip(output) == "Darwin"
  end

  defp ping_args(address) do
    wait_opt = if darwin?, do: "-W", else: "-w"
    ["-c", "1", wait_opt, "100", address]
  end

  defp parse_output(output) do
    alive? = not Regex.match?(~r/100(\.0)?% packet loss/, output)
    if alive? do
      Regex.run(~r/time=(\d+\.\d+) ms/, output)
      |> List.last
      |> String.to_float
    else
      nil
    end
  end
end
