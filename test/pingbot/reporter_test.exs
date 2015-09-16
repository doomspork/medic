defmodule Pingbot.ReporterTest do
  use ExUnit.Case

  alias Pingbot.Reporter

  test "transmits the ping report" do
    report = {:ok, "127.0.0.1", false}
    Reporter.handle_cast(report, [transport: Reporter.Inbox, dest: self])

    assert_receive %{address: "127.0.0.1", online: false}
  end
end
