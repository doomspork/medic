defmodule Medic.Checks.Get do
  @moduledoc """
  Make an HTTP Get request to a given address return the request body
  and time.
  """

  alias Medic.Report

  @user_agent "Medic"

  defmodule TimedRequest do
    @moduledoc """
    A wrapper for HTTPoison so can track the request time.
    """

    use HTTPoison.Base

    def request(method, url, body \\ "", headers \\ [], options \\ []) do
      :timer.tc(HTTPoison, :request, [method, url, body, headers, options])
    end
  end

  @doc """
  Perform a timed HTTP request for a given address.
  """
  def perform(%{target: address, id: id}) do
    {time, response} = TimedRequest.get(address, %{"User-Agent" => @user_agent})
    _body = case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      _ -> nil
    end

    time = time / 1000.0

    %Report{health_check_id: id, successful: not is_nil(time), response_time: time}
  end
end
