defmodule Medic.StorageTest do
  use ExUnit.Case

  alias Medic.Storage

  setup_all do
    Storage.start_link

    {:ok, []}
  end

  @checks [%{address: "example.org"}, %{address: "example.com"}]

  test "updates and retrieves list" do
    Storage.update(@checks)
    assert @checks = Storage.list
  end
end
