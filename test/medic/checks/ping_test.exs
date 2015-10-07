defmodule Medic.Checks.PingTest do
  use ExUnit.Case

  alias Medic.Checks.Ping

  @defaults %{target: "127.0.0.1", id: 1}

  test "reports successful pings" do
    assert %{health_check_id: 1, response_time: time} = Ping.perform(@defaults)
    assert is_float(time)
  end

  test "reports failed pings" do
    assert %{health_check_id: 1, response_time: nil} = Ping.perform(%{@defaults|target: "127.0.0.0"})
  end
end
