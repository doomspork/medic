defmodule Pingbot.StorageTest do
  use ExUnit.Case

  alias Pingbot.Storage

  setup_all do
    Storage.start_link ["example.org"]
    {:ok, []}
  end

  test "retrieves the list of hosts" do
    [h|_t] = Storage.list
    assert h == "example.org"
  end

  test "updates the list" do
    hosts = ["example.org", "example.com"]
    Storage.update(hosts)
    hosts = Storage.list
    assert length(hosts) == 2
  end
end
