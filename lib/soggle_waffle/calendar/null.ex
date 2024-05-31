defmodule SoggyWaffle.Calendar.Null do
  def utc_now do
    ~U[1970-01-01 00:00:00Z]
  end
end
