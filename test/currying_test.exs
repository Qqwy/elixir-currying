defmodule CurryingTest do
  use ExUnit.Case
  
  use Currying, operator: true
  doctest Currying

  test "the truth" do
    assert 1 + 1 == 2
  end
end
