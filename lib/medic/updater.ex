defmodule Medic.Updater do
  @moduledoc """
  Request health check updates from a remote host on a recurring basis.
  """

  use Medic.Recur

  alias Medic.Storage
  alias Medic.Check

  @doc """
  Request an updated list of of health checks from the configured destination.
  """
  def handle_cast(:tick, opts) do
    opts[:dest]
    |> request_list
    |> parse_response
    |> update_storage

    {:noreply, opts}
  end

  defp request_list(url), do: HTTPoison.get(url)

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    Poison.decode!(body, as: [Check])
  end

  defp parse_response({:ok, %{status_code: _others}}) do
    "Error occurred contacting the update server."
  end
  defp parse_response({:error, %HTTPoison.Error{reason: reason}}), do: reason

  defp update_storage(msg) when is_binary(msg), do: IO.error(msg)
  defp update_storage(data) when is_list(data) do
    Storage.update(data)
  end
end
