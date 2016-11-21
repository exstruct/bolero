defmodule Bolero.Modifiers do
  import Bolero.Utils

  def bind(domain, mod) do
    fn ->
      domain
      |> Bolero.generate()
      |> mod.()
    end
  end

  def oneof(list) when is_list(list) do
    list
    |> :erlang.list_to_tuple()
    |> oneof()
  end
  def oneof(tuple) when is_tuple(tuple) do
    size = tuple_size(tuple)
    fn ->
      :erlang.element(uniform(size), tuple)
      |> Bolero.generate()
    end
  end

  def pick(list) when is_list(list) do
    list
    |> :erlang.list_to_tuple()
    |> pick()
  end
  def pick(tuple) when is_tuple(tuple) do
    size = tuple_size(tuple)
    fn ->
      :erlang.element(uniform(size), tuple)
    end
  end

  def suchthat(domain, predicate) do
    fn ->
      suchthat_loop(domain, predicate, 100)
    end
  end

  defp suchthat_loop(_, _, 0) do
    exit :suchthat_failed
  end
  defp suchthat_loop(domain, predicate, count) do
    value = Bolero.generate(domain)

    value
    |> predicate.()
    |> case do
      true ->
        value
      false ->
        suchthat_loop(domain, predicate, count - 1)
    end
  end

  defmacro delay(call) do
    quote do
      fn ->
        unquote(call)
        |> Bolero.generate()
      end
    end
  end
end
