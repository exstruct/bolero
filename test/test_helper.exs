defmodule Test.Bolero.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Bolero
      import unquote(__MODULE__)
    end
  end

  defmacro btest([do: body, after: af]) do
    [{:->, _, [[value], assertions]}] = af
    name = Macro.to_string(body)
    quote do
      test unquote(name) do
        1..1000
        |> Enum.each(fn(_) ->
          unquote(value) = unquote(body) |> generate()
          unquote(assertions)
        end)
      end
    end
  end
end

ExUnit.start()
