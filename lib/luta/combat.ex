defmodule Luta.Combat do
  @moduledoc """
  The Combat module
  """

  alias Luta.{Battle, CombatServer}

  @doc """
  WIP
  """
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
    :ets.insert(combat, {:buffer_p1, %{list: [], size: 0}})

    :ets.insert(combat, {:p2, %{
      hps: arena.char2.hps,
      status: "normal",
      id: arena.p2_id,
      char: Map.from_struct arena.char2 |> Map.delete(:__meta__)
    }})
    :ets.insert(combat, {:buffer_p2, %{list: [], size: 0}})

    :ets.insert(combat, {:scena, -1})
    CombatServer.start_link(arena.id)

    arena
  end

  @doc """
  WIP
  """
  def actions(arena_id, user_id, action) do
    with {:ok, key} <- Battle.check_player!(arena_id, user_id) do
      combat = String.to_atom("arena@#{arena_id}")
      buffer = String.to_atom("buffer_#{key}")
      b_map = :ets.lookup(combat, buffer)[buffer]

      check_buffer(b_map, action) |> add_to_buffer(combat, buffer)
    end
  end

  defp check_buffer(b_map, action) do
    total_size = b_map.size + action.size
    case total_size <= 5 do
      true -> build_b_map(b_map, action, total_size)
      _ -> {:error}
    end
  end

  defp build_b_map(b_map, action, total_size) do
    Map.put(b_map, :list, b_map.list ++ [action])
    |> Map.put(:size, total_size)
  end

  defp add_to_buffer({:error}, _, _) do
    {:error, :cant_insert}
  end

  defp add_to_buffer(new_map, combat, buffer) do
    :ets.insert(combat, {buffer, new_map})
    {:ok, new_map}
  end

  @doc """
  WIP
  """
  def sync(arena_id) do
    combat = String.to_atom("arena@#{arena_id}")

    p1 = :ets.lookup(combat, :p1)[:p1]
    buffer_p1 = String.to_atom("buffer_#{:p1}")
    b_map_p1 = :ets.lookup(combat, buffer_p1)[buffer_p1].size

    p2 = :ets.lookup(combat, :p2)[:p2]
    buffer_p2 = String.to_atom("buffer_#{:p2}")
    b_map_p2 = :ets.lookup(combat, buffer_p2)[buffer_p2].size

    %{p1: p1, buffer_1: b_map_p1, p2: p2, buffer_2: b_map_p2}
  end
end
