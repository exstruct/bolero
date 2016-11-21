defmodule Bolero.Utils do
  @random_module (case Code.ensure_loaded?(:rand) do
    true -> :rand
    _ -> :random
  end)

  def uniform() do
    @random_module.uniform()
  end
  def uniform(num) do
    @random_module.uniform(num)
  end

  def foldn(0, acc, _) do
    acc
  end
  def foldn(count, acc, fun) do
    foldn(count - 1, fun.(acc), fun)
  end

  def collectable?(struct) do
    Collectable.into(struct)
    true
  rescue
    Protocol.UndefinedError ->
      false
  end
end
