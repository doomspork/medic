defmodule Medic.Checks.GetTest do
  use ExUnit.Case

  alias Medic.Checks.Get

  @defaults %{target: "example.com", id: 1}

  test "reports successful get" do
    assert %{health_check_id: 1, successful: success, response_time: time} = Get.perform(@defaults)
    assert success
    assert is_float(time)
  end
end
