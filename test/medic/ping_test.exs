defmodule Medic.PingTest do
  use ExUnit.Case

  alias Medic.Ping

  test "reports successful pings" do
    assert {:ok, "127.0.0.1", time} = Ping.ping("127.0.0.1")
    assert is_float(time)
  end

  test "reports failed pings" do
    assert {:ok, "127.0.0.0", false} = Ping.ping("127.0.0.0")
  end
end
