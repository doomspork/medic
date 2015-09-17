defmodule Medic.Report do
  defstruct address: nil,
            check_id: nil,
            results: %{},
            time: :os.system_time(:seconds)
end
