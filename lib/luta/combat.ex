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

    %{p1: p1, buffer_1_size: bp1, p2: p2, buffer_2_size: bp2, scena: scena}
  end


  @doc """
  WIP
  """
  def proc(_list, _combat) do
    :nada
  end

  @doc """
  WIP
  """
  def resolver(map) do
    flow(map.p1_card.type, map.p2_card.type)
    |> calcs(map)
  end

  defp flow(p1_type, p2_type) do
    case p1_type <> p2_type do
      "AA" -> :face
      "AW" -> :p2_set
      "AS" -> :p2_set
      "AD" -> :p1_guard

      "WA" -> :p1_set
      "Ww" -> :setup
      "WS" -> :setup
      "WD" -> :p2_adv

      "SA" -> :p1_set
      "SW" -> :setup
      "SS" -> :setup
      "SD" -> :p2_adv

      "DA" -> :p2_guard
      "DW" -> :p1_adv
      "DS" -> :p1_adv
      "DD" -> :duel
    end
  end

  def calcs(:p1_adv,map) do
    map
  end

  def calcs(:p1_set, map) do
    map
  end

  def calcs(:p1_guard, map) do
    map
  end

  def calcs(:p2_adv,map) do
    map
  end

  def calcs(:p2_set, map) do
    map
  end

  def calcs(:p2_guard, map) do
    p1 = ETS.lookup(map.combat, "p1")
    p2 = ETS.lookup(map.combat, "p2")

    dmg = map.p1_card.power + p1.atk
    neo_hps = p2.hps - (dmg - p2.def)
    p2 = %{ p2 | hps: neo_hps}

    ETS.update_player(map.combat, p2, :p2)
  end

  def calcs(:duel, map) do
    map.p1_card
    :nada
  end

  def calcs(:setup, map) do
    map.p1_card
    :nada
  end

  def calcs(:face, map) do
    map.p1_card
    :nada
  end

  def damager(player, target, dmg) do
    if dmg > 0, do: target.hps - (player.atk + dmg), else: target.hps
  end
end
