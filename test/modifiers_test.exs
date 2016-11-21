defmodule Test.Bolero.Modifiers do
  use Test.Bolero.Case

  btest do
    string()
    |> bind(&("/" <> &1))
  after value ->
    assert "/" <> _ = value
  end

  btest do
    oneof([int(), real()])
  after value ->
    assert is_number(value)
  end

  btest do
    pick([:cat, :dog, :rat])
  after value ->
    assert value in [:cat, :dog, :rat]
  end

  btest do
    int()
    |> suchthat(&(&1 > 0))
  after value ->
    assert value > 0
  end
end
