defmodule SoggyWaffle do
  defstruct [:weather_api]

  def create_null(attrs \\ []) do
    default_attrs = %{weather_api: SoggyWaffle.WeatherApi.create_null()}
    attrs = Enum.into(attrs, default_attrs)
    struct!(__MODULE__, attrs)
  end

  def create_error_null do
    weather_api = SoggyWaffle.WeatherApi.create_error_null()
    create_null(weather_api: weather_api)
  end

  def create do
    struct!(__MODULE__, weather_api: SoggyWaffle.WeatherApi.create())
  end

  def rain?(service \\ create(), city, date_time) do
    with {:ok, response} <- SoggyWaffle.WeatherApi.get_forecast(service.weather_api, city) do
      weather_data =
        SoggyWaffle.WeatherApi.ResponseParser.parse_response(response)

      {:ok, SoggyWaffle.Weather.imminent_rain?(weather_data, date_time)}
    end
  end
end
