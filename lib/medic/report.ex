defmodule Medic.Report do
  @moduledoc """
  Struct representation of a health check report.
  """

  defstruct address: nil,
            check_id: nil,
            results: %{},
            time: :os.system_time(:seconds)
end
