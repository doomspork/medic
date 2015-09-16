defmodule Pingbot.Ping do
  @moduledoc """
  Ping an IP or hostname, notifying the Reporter of the outcome
  """

  @doc """
  Ping an address and send a tuple back to the parent saying what
  has happened:
  `{:ok, ip, time}` where `time` tells us the response time or false if it is down.
  `{:error, ip, error}` when some error caused us to not be able to run the
  ping command.
  """
  def ping(address) do
    try do
      {cmd_output, _} = System.cmd("ping", ping_args(address))
      time = parse_output(cmd_output)
      {:ok, address, time}
    rescue
      e -> {:error, address, e}
    end
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
      false
    end
  end
end
