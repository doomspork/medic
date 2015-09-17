defmodule Medic.Checks.PingTest do
  use ExUnit.Case

  alias Medic.Checks.Ping

  @defaults %{address: "127.0.0.1", id: 1}

  test "reports successful pings" do
    assert %{check_id: 1, results: %{time: time}} = Ping.perform(@defaults)
    assert is_float(time)
  end

  test "reports failed pings" do
    assert %{check_id: 1, results: %{time: nil}} = Ping.perform(%{@defaults|address: "127.0.0.0"})
  end
end
