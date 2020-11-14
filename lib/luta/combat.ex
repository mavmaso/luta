defmodule Luta.Combat do
  @moduledoc """
  The Combat module
  """

  alias Luta.Battle

  def start(%Battle.Arena{} = arena) do
    {:ok, arena} = Battle.update_arena(arena, %{status: "fighting"})
    arena = Luta.Repo.preload(arena, [:char1, :char2])
    table = "arena@#{arena.id}"
    combat = :ets.new(String.to_atom(table), [:set, :named_table, :public])

    :ets.insert(combat, {:p1, %{
      hps: arena.char1.hps,
      status: "normal",
      id: arena.p1_id,
      char: Map.from_struct arena.char1 |> Map.delete(:__meta__)
    }})
    # :ets.lookup(combat, :p1) |> IO.inspect

    arena
  end
end
