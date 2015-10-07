defmodule Medic.Updater do
  @moduledoc """
  Request health check updates from a remote host on a recurring basis.
  """
  use Medic.Recur

  require Logger

  alias Medic.Storage
  alias Medic.Check

  @auth_token Application.get_env(:medic, :auth_token)

  @doc """
  Request an updated list of of health checks.
  """
  def handle_cast(:tick, opts) do
    opts[:dest]
    |> request_list
    |> parse_response
    |> update_storage

    {:noreply, opts}
  end

  defp request_list(url), do: HTTPoison.get(url, [{"Authorization", "Bearer " <> @auth_token}])

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    %{"data" => checks} = Poison.decode!(body, as: %{"data" => [Check]})
    checks
  end

  defp parse_response({:ok, %{status_code: _others}}) do
    Logger.error "Error occurred contacting the update server."
  end
  defp parse_response({:error, %HTTPoison.Error{reason: reason}}), do: reason

  defp update_storage(msg) when is_binary(msg), do: IO.error(msg)
  defp update_storage(data) when is_list(data) do
    Storage.update(data)
  end
end
