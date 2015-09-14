defmodule Pingbot.ReporterTest do
  use ExUnit.Case

  alias Pingbot.Reporter

  defmodule TestTransmittor do
    def transmit(dest, report), do: send(dest, report)
  end

  test "transmits the ping report" do
    report = {:ok, "127.0.0.1", false}
    Reporter.report(report, [transport: TestTransmittor, dest: self])

    assert_receive %{address: "127.0.0.1", online: false}
  end
end
