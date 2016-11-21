defmodule Bolero.Generators do
  import Bolero.{Modifiers,Utils}

  @big_int :math.pow(2, 60) |> trunc()

  def any() do
    oneof([
      int(), real(), bool(), atom(), binary()
    ])
  end

  def atom() do
    atom(0, 255)
  end
  def atom(size) do
    charlist(size)
    |> bind(&:erlang.list_to_atom/1)
  end
  def atom(min_size, max_size) do
    charlist(min_size, max_size)
    |> bind(&:erlang.list_to_atom/1)
  end

  def binary() do
    binary(0, 100)
  end
  def binary(size) do
    list(byte(), size)
    |> bind(&:erlang.list_to_binary/1)
  end
  def binary(min_size, max_size) do
    list(byte(), min_size, max_size)
    |> bind(&:erlang.list_to_binary/1)
  end

  def bool() do
    fn ->
      uniform(2) == 1
    end
  end

  def byte() do
    int(0, 255)
  end

  def char() do
    int(33, 126)
  end
  def char_alpha() do
    oneof([char_lower(), char_upper()])
  end
  def char_numeric() do
    int(?0, ?9)
  end
  def char_lower() do
    int(?a, ?z)
  end
  def char_upper() do
    int(?A, ?Z)
  end

  def charlist() do
    list(char())
  end
  def charlist(size) do
    list(char(), size)
  end
  def charlist(min_size, max_size) do
    list(char(), min_size, max_size)
  end

  def int() do
    int(-@big_int, @big_int)
  end
  def int(max) do
    int(0, max)
  end
  def int(min, max) do
    diff = max - min + 1
    fn ->
      uniform(diff) + min - 1
    end
  end

  def list(list) when is_list(list) do
    fn ->
      Enum.map(list, &Bolero.generate/1)
    end
  end
  def list(domain) do
    list(domain, 0, 100)
  end
  def list(domain, size) do
    fn ->
      size
      |> foldn([], fn(acc) ->
        [Bolero.generate(domain) | acc]
      end)
    end
  end
  def list(domain, min_size, max_size) do
    int(min_size, max_size)
    |> bind(fn(size) ->
      list(domain, size).()
    end)
  end

  def map(kvs, collectable \\ %{})
  def map(kvs, collectable) do
    cond do
      collectable?(collectable) ->
        fn ->
          kvs
          |> Stream.map(fn({k, v}) ->
            {k, Bolero.generate(v)}
          end)
          |> Enum.into(collectable)
        end
      true ->
        fn ->
          kvs
          |> Enum.reduce(collectable, fn({k, v}, acc) ->
            %{acc | k => Bolero.generate(v)}
          end)
        end
    end
  end

  def real() do
    real(-@big_int, @big_int)
  end
  def real(max) do
    real(0.0, max)
  end
  def real(min, max) do
    diff = max - min
    fn ->
      (uniform() * diff) + min
    end
  end

  def return(value) do
    fn -> value end
  end

  def string() do
    charlist()
    |> bind(&:erlang.list_to_binary/1)
  end
  def string(size) do
    charlist(size)
    |> bind(&:erlang.list_to_binary/1)
  end
  def string(min_size, max_size) do
    charlist(min_size, max_size)
    |> bind(&:erlang.list_to_binary/1)
  end

  def string_join(domains) do
    fn ->
      domains
      |> Stream.map(&Bolero.generate/1)
      |> Enum.join()
    end
  end

  def tuple(tuple) when is_tuple(tuple) do
    tuple
    |> :erlang.tuple_to_list()
    |> tuple()
  end
  def tuple(domain) do
    list(domain)
    |> bind(&:erlang.list_to_tuple/1)
  end
  def tuple(domain, size) do
    list(domain, size)
    |> bind(&:erlang.list_to_tuple/1)
  end
  def tuple(domain, min_size, max_size) do
    list(domain, min_size, max_size)
    |> bind(&:erlang.list_to_tuple/1)
  end

  def unicode_char() do
    &random_unicode_char/0
  end

  def unicode_charlist() do
    list(unicode_char())
  end
  def unicode_charlist(size) do
    list(unicode_char(), size)
  end
  def unicode_charlist(min_size, max_size) do
    list(unicode_char(), min_size, max_size)
  end

  def unicode_string() do
    unicode_string(:utf8)
  end
  def unicode_string(size) when is_integer(size) do
    unicode_string(size, :utf8)
  end
  def unicode_string(encoding) when is_atom(encoding) do
    unicode_charlist()
    |> bind(&:unicode.characters_to_binary(&1, :unicode, encoding))
  end
  def unicode_string(min_size, max_size) when is_integer(min_size) and is_integer(max_size) do
    unicode_string(min_size, max_size, :utf8)
  end
  def unicode_string(size, encoding) when is_integer(size) and is_atom(encoding) do
    unicode_charlist(size)
    |> bind(&:unicode.characters_to_binary(&1, :unicode, encoding))
  end
  def unicode_string(min_size, max_size, encoding) do
    unicode_charlist(min_size, max_size)
    |> bind(&:unicode.characters_to_binary(&1, :unicode, encoding))
  end

  defp random_unicode_char() do
    case uniform(0x10FFFF + 1) - 1 do
      c when c in 0x20..0x7E
          or c in 0xA0..0xD7FF
          or c in 0xE000..0xFFFD
          or c in 0x10000..0x10FFFF ->
        c
      _ ->
        random_unicode_char()
    end
  end
end
