defmodule Luta.ETS do
  @moduledoc """
  The module responsable for ETS
  """

  @doc """
  WIP
  """
  def start_table(arena_id) do
    :ets.new(Utils.combat_atom(arena_id), [:set, :named_table, :public])
  end

  @doc """
  WIP
  """
  def delete_table(arena_id) do
    :ets.delete(Utils.combat_atom(arena_id))
  end

  @doc """
  WIP
  """
  def lookup(table, target) do
    key = String.to_atom("#{target}")
    :ets.lookup(table, key)[key]
  end

  @doc """
  WIP
  """
  def insert_scena(table, content) do
    :ets.insert(table, {:scena, content})
  end

  @doc """
  WIP
  """
  def insert_player(table, arena, :p1) do
    :ets.insert(table, {:p1, %{
      id: arena.p1_id,
      char_id: arena.char1_id,
      hps: arena.char1.hps,
      status: ["normal"],
      buff: [],
      debuff: [],
      atk: arena.char1.atk,
      def: arena.char1.def,
      spd: arena.char1.spd,
    }})
    :ets.insert(table, {:buffer_p1, []})
  end

  def insert_player(table, arena, :p2) do
    :ets.insert(table, {:p2, %{
      id: arena.p2_id,
      char_id: arena.char2_id,
      hps: arena.char2.hps,
      status: ["normal"],
      buff: [],
      debuff: [],
      atk: arena.char2.atk,
      def: arena.char2.def,
      spd: arena.char2.spd,
    }})
    :ets.insert(table, {:buffer_p2, []})
  end

  @doc """
  WIP
  """
  def update_player(table, status, :p1) do
    :ets.insert(table, {:p1, status})
  end

  def update_player(table, status, :p2) do
    :ets.insert(table, {:p2, status})
  end

  @doc """
  WIP
  """
  def insert_buffer(table, content, key) do
    #TODO
    :ets.insert(table, {key, content})
  end

  @doc """
  WIP
  """
  def insert_stage(table, content) do
    :ets.insert(table, {:stage, content})
  end
end
