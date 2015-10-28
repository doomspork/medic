defmodule Medic.Report do
  @moduledoc """
  Struct representation of a health check report.
  """

  defstruct response_time: nil,
            health_check_id: nil,
            successful: false,
            time: nil
end
