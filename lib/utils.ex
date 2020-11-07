defmodule Utils do
  def atomify_map(%{} = map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), atomify_map(v)} end)
  end

  def atomify_map(not_a_map), do: not_a_map
end
