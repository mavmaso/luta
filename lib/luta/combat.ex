defmodule Luta.Combat do
  @moduledoc """
  The Combat module
  """

  alias Luta.{Battle, CombatServer, ETS}

  @doc """
  WIP
  """
  def start(%Battle.Arena{} = arena) do
    {:ok, arena} = Battle.update_arena(arena, %{status: "fighting"})
    new_arena = Luta.Repo.preload(arena, [:char1, :char2])
    combat = ETS.start_table(new_arena.id)
    ETS.insert_player(combat, new_arena, :p1)
    ETS.insert_player(combat, new_arena, :p2)

    ETS.insert_scena(combat, -1)
    CombatServer.start_link(new_arena.id)

    new_arena
  end

  @doc """
  WIP
  """
  def actions(arena_id, user_id, action) do
    with {:ok, key} <- Battle.check_player!(arena_id, user_id) do
      combat = Utils.combat_atom(arena_id)
      key = String.to_atom("buffer_#{key}")
      buffer = ETS.lookup(combat, key)

      check_buffer(buffer, action) |> add_to_buffer(combat, key)
    end
  end

  defp check_buffer(buffer, action) do
    # total_size = length(buffer) + 1
    case length(buffer) + 1 <= 3 do
      true -> buffer ++ [action]
      _ -> {:error}
    end
  end

  defp add_to_buffer({:error}, _, _) do
    {:error, :cant_insert}
  end

  defp add_to_buffer(buffer, combat, key) do
    ETS.insert_buffer(combat, buffer, key)
    {:ok, buffer}
  end

  @doc """
  WIP
  """
  def sync(arena_id) do
    combat = Utils.combat_atom(arena_id)
    scena = ETS.lookup(combat, "scena")

    p1 = ETS.lookup(combat, "p1")
    bp1 = ETS.lookup(combat, "buffer_p1") |> length()

    p2 = ETS.lookup(combat, "p2")
    bp2 = ETS.lookup(combat, "buffer_p2") |> length()

    stage = ETS.lookup(combat, "stage")

    %{p1: p1, buffer_1_size: bp1, p2: p2, buffer_2_size: bp2, scena: scena, narrator: narrator(stage)}
  end

  defp narrator([%{narrative: n_1}, %{narrative: n_2}]) do
    [n_1, n_2]
  end

  @doc """
  WIP
  """
  def proc([%{dmg: dmg_1} = action_1, %{dmg: dmg_2} = action_2], combat)
    when (dmg_1 != 0 or dmg_2 != 0) do
      IO.inspect action_2
    # WIP
    p1 = ETS.lookup(combat, :p1)
    p2 = ETS.lookup(combat, :p2)

    hp_p1 = damager(p2, p1, action_2.dmg)
    hp_p2 = damager(p1, p2, action_1.dmg)

    new_p1 = %{p1 | hps: hp_p1}
    new_p2 = %{p2 | hps: hp_p2}

    ETS.update_player(combat, new_p1, :p1)
    ETS.update_player(combat, new_p2, :p2)
  end

  def proc([%{buff: buff_1} = action_1, %{buff: buff_2} = action_2], combat)
    when (length(buff_1) > 0 or length(buff_2) > 0) do
      [action_1, action_2, combat]
  end

  def proc(_list, _combat) do
    :nada
  end

  defp damager(player, target, dmg) do
    if dmg > 0, do: target.hps - (player.atk + dmg), else: target.hps
  end
end
