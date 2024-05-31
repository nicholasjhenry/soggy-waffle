defmodule SoggyWaffle.WeatherApi do
  defstruct [:http_client]

  alias SoggyWaffle.HttpClient

  defmodule Responses do
    def success_response(_result) do
      now = SoggyWaffle.Calendar.Null.utc_now()
      thunderstorm = 231

      data = %{
        "list" => [
          %{
            "dt" => DateTime.to_unix(now),
            "weather" => [%{"id" => thunderstorm}]
          }
        ]
      }

      {:ok, %SoggyWaffle.HttpClient.Response{status_code: 200, body: data}}
    end

    def error_response(_result) do
      {:error, {:status, 401}}
    end
  end

  def create_null(attrs \\ []) do
    http_client =
      SoggyWaffle.HttpClient.create_null(
        response_handler: &SoggyWaffle.WeatherApi.Responses.success_response/1
      )

    default_attrs = %{http_client: http_client}
    attrs = Enum.into(attrs, default_attrs)

    struct!(__MODULE__, attrs)
  end

  def create_error_null(attrs \\ []) do
    http_client =
      SoggyWaffle.HttpClient.create_null(
        response_handler: &SoggyWaffle.WeatherApi.Responses.error_response/1
      )

    default_attrs = %{http_client: http_client}
    attrs = Enum.into(attrs, default_attrs)

    struct!(__MODULE__, attrs)
  end

  def create do
    attrs = [http_client: SoggyWaffle.HttpClient.create()]
    struct!(__MODULE__, attrs)
  end

  def get_forecast(weather_api, city) when is_binary(city) do
    app_id = "foo"
    params = %{"q" => city, "APPID" => app_id}
    url = "https://api.openweathermap.org/data/2.5/forecast"

    HttpClient.get(weather_api.http_client, url, params)
  end
end
