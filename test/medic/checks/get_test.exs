defmodule Medic.Checks.GetTest do
  use ExUnit.Case

  alias Medic.Checks.Get

  @defaults %{address: "example.com", id: 1}

  test "reports successful get" do
    assert %{check_id: 1, results: %{body: body, time: time}} = Get.perform(@defaults)
    assert is_float(time)
    assert is_binary(body)
  end
end
