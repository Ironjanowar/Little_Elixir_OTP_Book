defmodule Blitzy.Worker do
  use Timex

  def start(url) do
    {timestamp, response} = Duration.measure(&HTTPoison.get/1, [url])
    handle_response({Duration.to_milliseconds(timestamp), response})
  end

  defp handle_response({msecs, {:ok, %HTTPoison.Response{status_code: code}}})
       when code >= 200 and code <= 304,
       do: {:ok, msecs}

  defp handle_response({_msecs, {:error, reason}}), do: {:error, reason}
  defp handle_response({_msecs, _}), do: {:error, :unknown}
end
