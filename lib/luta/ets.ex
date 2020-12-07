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
      hps: arena.char1.hps,
      status: "normal",
      id: arena.p1_id,
      char: Map.from_struct arena.char1 |> Map.delete(:__meta__)
    }})
    :ets.insert(table, {:buffer_p1, []})
  end

  def insert_player(table, arena, :p2) do
    :ets.insert(table, {:p2, %{
      hps: arena.char2.hps,
      status: "normal",
      id: arena.p2_id,
      char: Map.from_struct arena.char2 |> Map.delete(:__meta__)
    }})
    :ets.insert(table, {:buffer_p2, []})
  end

  @doc """
  WIP
  """
  def insert_buffer(table, content, key) do
    #TODO
    :ets.insert(table, {key, content})
  end
end
