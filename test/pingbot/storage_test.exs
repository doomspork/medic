defmodule Pingbot.StorageTest do
  use ExUnit.Case

  alias Pingbot.Storage

  setup_all do
    Storage.start_link

    {:ok, []}
  end

  test "updates and retrieves list" do
    hosts = ["example.org", "example.com"]
    Storage.update(hosts)
    assert ^hosts = Storage.list
  end
end
