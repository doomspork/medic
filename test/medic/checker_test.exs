defmodule Medic.CheckerTest do
  use ExUnit.Case

  alias Medic.Checker
  alias Medic.Reporter
  alias Medic.Storage

  setup_all do
    check = %{target: "127.0.0.1", type: :ping, id: 1}
    Storage.start_link([check])

    {:ok, []}
  end

  test "checks continuously" do
    Reporter.start_link(transport: Reporter.Inbox, dest: self())
    Checker.start_link(interval: 500)
    :timer.sleep(1200)

    assert_received %{health_check_id: 1, successful: true, response_time: _time}
    assert_received %{health_check_id: 1, successful: true, response_time: _time}
  end
end
