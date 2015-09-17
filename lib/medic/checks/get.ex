defmodule Medic.Checks.Get do
  alias Medic.Report

  defmodule TimedRequest do
    use HTTPoison.Base

    def request(method, url, body \\ "", headers \\ [], options \\ []) do
      :timer.tc(HTTPoison, :request, [method, url, body, headers, options])
    end
  end

  def perform(%{address: address, id: id}) do
    {time, response} = TimedRequest.get(address)

    body = case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> nil
    end

    time = time / 1000.0

    %Report{address: address, check_id: id, results: %{body: body, time: time}}
  end
end
