defmodule Pingbot.PingTest do
  use ExUnit.Case

  alias Pingbot.Ping

  test "reports successful pings" do
    Ping.ping("127.0.0.1", self)

    assert_receive {:ok, "127.0.0.1", time}
    assert is_float(time)
  end

  test "reports failed pings" do
    Ping.ping("127.0.0.0", self)
    assert_receive {:ok, "127.0.0.0", false}
  end
end
