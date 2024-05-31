defmodule SoggyWaffle.WeatherControllerTest do
  use ExUnit.Case

  test "determines rain" do
    conn = %{service: SoggyWaffle.create_null()}
    response = SoggyWaffle.WeatherController.show(conn, %{"city" => "Montreal"})
    assert response.status == 200
    assert response.body == Jason.encode!(%{rain: false})
  end

  test "handle error" do
    conn = %{service: SoggyWaffle.create_error_null()}
    response = SoggyWaffle.WeatherController.show(conn, %{"city" => "Montreal"})
    assert response.status == 500
  end
end
