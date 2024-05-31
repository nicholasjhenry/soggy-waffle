defmodule SoggyWaffle.WeatherController do
  def show(conn, %{"city" => city}) do
    case SoggyWaffle.rain?(conn.service, city, DateTime.utc_now()) do
      {:ok, rain?} ->
        %{status: 200, body: Jason.encode!(%{rain: rain?})}

      {:error, _} ->
        %{status: 500}
    end
  end
end
