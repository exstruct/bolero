defmodule Test.Bolero.Generators do
  use Test.Bolero.Case

  btest do
    atom()
  after value ->
    assert is_atom(value)
  end

  btest do
    atom(10)
  after value ->
    assert is_atom(value)
    assert byte_size(to_string(value)) == 10
  end

  btest do
    atom(20, 30)
  after value ->
    assert is_atom(value)
    assert byte_size(to_string(value)) >= 20
    assert byte_size(to_string(value)) <= 30
  end

  btest do
    binary()
  after value ->
    assert is_binary(value)
  end

  btest do
    binary(40)
  after value ->
    assert is_binary(value)
    assert byte_size(value) == 40
  end

  btest do
    binary(30, 40)
  after value ->
    assert is_binary(value)
    assert byte_size(value) <= 40
    assert byte_size(value) >= 30
  end

  btest do
    bool()
  after value ->
    assert is_boolean(value)
  end

  btest do
    byte()
  after value ->
    assert is_integer(value)
    assert value >= 0
    assert value <= 255
  end

  btest do
    char()
  after value ->
    assert is_integer(value)
  end

  btest do
    char_alpha()
  after value ->
    assert is_integer(value)
  end

  btest do
    char_numeric()
  after value ->
    assert is_integer(value)
  end

  btest do
    char_lower()
  after value ->
    assert is_integer(value)
  end

  btest do
    char_upper()
  after value ->
    assert is_integer(value)
  end

  btest do
    charlist()
  after value ->
    assert is_list(value)
    assert value |> to_string() |> String.printable?()
  end

  btest do
    charlist(10)
  after value ->
    assert is_list(value)
    assert value |> to_string() |> String.printable?()
    assert length(value) == 10
  end

  btest do
    charlist(20, 30)
  after value ->
    assert is_list(value)
    assert value |> to_string() |> String.printable?()
    assert length(value) >= 20
    assert length(value) <= 30
  end

  btest do
    int()
  after value ->
    assert is_integer(value)
  end

  btest do
    int(10)
  after value ->
    assert is_integer(value)
    assert value >= 0
    assert value <= 10
  end

  btest do
    int(-10, 10)
  after value ->
    assert is_integer(value)
    assert value >= -10
    assert value <= 10
  end

  btest do
    list(byte())
  after value ->
    assert is_list(value)
    assert :erlang.list_to_binary(value)
  end

  btest do
    list(byte(), 1)
  after value ->
    assert is_list(value)
    assert [v] = value
    assert is_integer(v)
  end

  btest do
    list(byte(), 5, 10)
  after value ->
    assert is_list(value)
    assert length(value) >= 5
    assert length(value) <= 10
  end

  btest do
    [foo: atom()]
    |> map()
  after value ->
    assert is_map(value)
    assert is_atom(value.foo)
  end

  btest do
    [port: int(10_000)]
    |> map(%URI{})
  after value ->
    assert %URI{port: port} = value
    assert is_integer(port)
  end

  btest do
    real()
  after value ->
    assert is_float(value)
  end

  btest do
    real(1)
  after value ->
    assert is_float(value)
    assert value >= 0.0
    assert value <= 1.0
  end

  btest do
    real(10, 20)
  after value ->
    assert is_float(value)
    assert value >= 10.0
    assert value <= 20.0
  end

  btest do
    return(int())
  after value ->
    assert is_function(value)
  end

  btest do
    return("Test")
  after value ->
    assert is_binary(value)
  end

  btest do
    string()
  after value ->
    assert is_binary(value)
    assert String.printable?(value)
  end

  btest do
    string(20)
  after value ->
    assert is_binary(value)
    assert byte_size(value) == 20
    assert String.printable?(value)
  end

  btest do
    string(30, 40)
  after value ->
    assert is_binary(value)
    assert byte_size(value) >= 30
    assert byte_size(value) <= 40
    assert String.printable?(value)
  end

  btest do
    string_join([string(), "@", byte()])
  after value ->
    assert is_binary(value)
    assert String.contains?(value, "@")
  end

  btest do
    tuple({int(), real(), binary()})
  after value ->
    assert {a, b, c} = value
    assert is_integer(a)
    assert is_float(b)
    assert is_binary(c)
  end

  btest do
    tuple(int())
  after value ->
    assert is_tuple(value)
  end

  btest do
    tuple(int(), 4)
  after value ->
    assert {a, _, _, _} = value
    assert is_integer(a)
  end

  btest do
    tuple(int(), 5, 10)
  after value ->
    assert tuple_size(value) >= 5
    assert tuple_size(value) <= 10
  end

  btest do
    unicode_char()
  after value ->
    assert is_integer(value)
  end

  btest do
    unicode_charlist()
  after value ->
    assert is_list(value)
    assert value |> :unicode.characters_to_binary() |> is_binary()
  end

  btest do
    unicode_charlist(10)
  after value ->
    assert length(value) == 10
    assert (value |> :unicode.characters_to_binary() |> byte_size()) > 10
  end

  btest do
    unicode_charlist(15, 25)
  after value ->
    assert length(value) >= 15
    assert length(value) <= 25
  end

  btest do
    unicode_string()
  after value ->
    assert is_binary(value)
    assert String.printable?(value)
  end

  btest do
    unicode_string(10)
  after value ->
    assert byte_size(value) >= 10
    assert String.printable?(value)
  end

  btest do
    unicode_string(:utf16)
  after value ->
    assert is_binary(value)
  end

  btest do
    unicode_string(0, 10)
  after value ->
    assert is_binary(value)
  end

  btest do
    unicode_string(10, :utf32)
  after value ->
    assert is_binary(value)
  end

  btest do
    unicode_string(30, 40, :utf16)
  after value ->
    assert is_binary(value)
  end
end
