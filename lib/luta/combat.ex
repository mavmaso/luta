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
    :ets.insert(combat, {:queue_p1, %{list: [], size: 0}})

    :ets.insert(combat, {:p2, %{
      hps: arena.char2.hps,
      status: "normal",
      id: arena.p2_id,
      char: Map.from_struct arena.char2 |> Map.delete(:__meta__)
    }})
    :ets.insert(combat, {:queue_p2, %{list: [], size: 0}})

    arena
  end

  def actions(arena_id, user_id, action) do
    with {:ok, key} <- Battle.check_player(arena_id, user_id) do
      combat = String.to_atom("arena@#{arena_id}")
      queue = String.to_atom("queue_#{key}")
      q_map = :ets.lookup(combat, queue)[queue]

      check_queue(q_map, action) |> add_to_queue(combat, queue)
    end
  end

  defp check_queue(q_map, action) do
    total_size = q_map.size + String.to_integer(action.size)
    case total_size <= 5 do
      true -> build_q_map(q_map, action, total_size)
      _ -> {:error}
    end
  end

  defp build_q_map(q_map, action, total_size) do
    Map.put(q_map, :list, q_map.list ++ [action])
    |> Map.put(:size, total_size)
  end

  defp add_to_queue({:error}, _, _) do
    {:error, :cant_insert}
  end

  defp add_to_queue(new_map, combat, queue) do
    :ets.insert(combat, {queue, new_map})
    {:ok, new_map}
  end
end
