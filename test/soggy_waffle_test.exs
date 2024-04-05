defmodule SoggyWaffleTest do
  use ExUnit.Case
  doctest SoggyWaffle

  test "greets the world" do
    assert SoggyWaffle.hello() == :world
  end
end
