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
      "WW" -> :setup
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

  defp calcs(:p1_adv,map) do
    map
  end

  defp calcs(:p1_set, map) do
    map
  end

  defp calcs(:p1_guard, map) do
    [p1, p2] = get_players(map.combat)

    dmg = map.p2_card.power + p2.atk
    neo_hps = p1.hps - (dmg - p1.def)
    p1 = %{ p1 | hps: neo_hps}

    ETS.update_player(map.combat, p1, :p1)
    proc(map)
  end

  defp calcs(:p2_adv,map) do
    map
  end

  defp calcs(:p2_set, map) do
    map
  end

  defp calcs(:p2_guard, map) do
    [p1, p2] = get_players(map.combat)

    dmg = map.p1_card.power + p1.atk
    neo_hps = p2.hps - (dmg - p2.def)
    p2 = %{ p2 | hps: neo_hps}

    ETS.update_player(map.combat, p2, :p2)
    proc(map)
  end

  defp calcs(:duel, map) do
    [p1, p2] = get_players(map.combat)

    compare = map.p1_card.start_up - map.p2_card.start_up

    cond do
      compare == 0 -> Enum.random([:p1, :p2])
      compare >= 1 -> :p1
      compare <= 1 -> :p2
    end
    |> dmg_order(map, p1, p2)
  end

  defp calcs(:setup, map) do
    map.p1_card
    :nada
  end

  defp calcs(:face, map) do
    proc(map)
    :face
  end

  def get_players(combat) do
    p1 = ETS.lookup(combat, "p1")
    p2 = ETS.lookup(combat, "p2")
    [p1,p2]
  end

  defp simple_dmg_p1(map, p1, p2) do
    dmg = map.p1_card.power + p1.atk
    neo_hps = p2.hps - dmg
    p2 = %{ p2 | hps: neo_hps}

    ETS.update_player(map.combat, p2, :p2)
    map
  end

  defp simple_dmg_p2(map, p2, p1) do
    dmg = map.p2_card.power + p2.atk
    neo_hps = p1.hps - dmg
    p1 = %{ p1 | hps: neo_hps}

    ETS.update_player(map.combat, p1, :p1)
    map
  end

  defp dmg_order(:p1 = _order, map, p1, p2) do
    simple_dmg_p1(map, p1, p2)
    simple_dmg_p2(map, p2, p1)
  end

  defp dmg_order(:p2 = _order, map, p1, p2) do
    simple_dmg_p2(map, p2, p1)
    simple_dmg_p1(map, p1, p2)
  end

  @doc """
  WIP
  """
  def proc(map) do
    [p1, p2] = get_players(map.combat)
    check_defeat(p1, map.arena_id)
    check_defeat(p2, map.arena_id)
    :nada
  end

  def check_defeat(player, arena_id) do
    if player.hps < 0 do
      {:ok, player_atom} = Battle.check_player!(arena_id, player.id)

      Battle.get_arena!(arena_id)
      |> Battle.close_arena(player_atom, player)
    end
  end
end
