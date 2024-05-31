defmodule SoggyWaffleTest do
  use ExUnit.Case

  test "determines if rain is forecasted" do
    result = rain?("Montreal", &SoggyWaffle.WeatherApi.Responses.success_response/1)
    assert result == {:ok, false}
  end

  test "handles an error response" do
    result = rain?("Montreal", &SoggyWaffle.WeatherApi.Responses.error_response/1)

    assert result == {:error, {:status, 401}}
  end

  defp rain?(city, response_handler) do
    weather_api =
      SoggyWaffle.WeatherApi.create_null(
        http_client: SoggyWaffle.HttpClient.create_null(response_handler: response_handler)
      )

    service = SoggyWaffle.create_null(weather_api: weather_api)

    date_time = DateTime.from_unix(0)
    SoggyWaffle.rain?(service, city, date_time)
  end
end
