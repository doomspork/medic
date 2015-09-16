defmodule Pingbot.CheckerTest do
  use ExUnit.Case

  alias Pingbot.Checker
  alias Pingbot.Reporter
  alias Pingbot.Storage

  setup_all do
    Storage.start_link(["127.0.0.1"])

    {:ok, []}
  end

  test "checks continuously" do
    Reporter.start_link(transport: Reporter.Inbox, dest: self())
    Checker.start_link(interval: 500)
    :timer.sleep(1200)

    assert_received %{address: "127.0.0.1", online: true, ms: _time}
    assert_received %{address: "127.0.0.1", online: true, ms: _time}
  end
end
