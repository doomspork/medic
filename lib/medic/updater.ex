defmodule Medic.Updater do
  use Medic.Recur

  alias Medic.Storage

  def handle_cast(:tick, opts) do
    opts[:dest]
    |> request_list
    |> parse_response
    |> update_storage

    {:noreply, opts}
  end

  defp request_list(url), do: HTTPoison.get(url)

  defp parse_response({:ok, %{status_code: 200, body: body}}), do: Poison.decode!(body)
  defp parse_response({:ok, %{status_code: _others}}) do
    "Error occurred contacting the update server."
  end
  defp parse_response({:error, %HTTPoison.Error{reason: reason}}), do: reason

  defp update_storage(msg) when is_binary(msg), do: IO.error(msg)
  defp update_storage(data) when is_list(data) do
    Storage.update(data)
  end
end
