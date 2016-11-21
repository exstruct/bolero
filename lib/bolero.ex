defmodule Bolero do
  defmacro __using__(_) do
    quote do
      import Bolero.{Generators,Modifiers}
      import Bolero
    end
  end

  def generate(fun) when is_function(fun) do
    fun.()
  end
  def generate(value) when is_atom(value) or is_binary(value) or is_number(value) do
    value
  end
end
