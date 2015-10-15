defmodule Medic.Updater do
  @moduledoc """
  Request health check updates from a remote host on a recurring basis.
  """
  use Medic.Recur

  require Logger

  alias Medic.Storage
  alias Medic.Check

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

  @doc false
  defp auth_token, do: Application.get_env(:medic, :auth_token)

  @doc false
  defp request_list(url), do: HTTPoison.get(url, [{"Authorization", "Bearer " <> auth_token}])

  @doc false
  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    %{"data" => checks} = Poison.decode!(body, as: %{"data" => [Check]})
    checks
  end

  @doc false
  defp parse_response({:ok, %{status_code: _others}}) do
    Logger.error "Error occurred contacting the update server."
  end
  defp parse_response({:error, %HTTPoison.Error{reason: reason}}), do: reason

  @doc false
  defp update_storage(msg) when is_binary(msg), do: IO.error(msg)
  defp update_storage(data) when is_list(data) do
    Storage.update(data)
  end
end
