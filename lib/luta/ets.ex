defmodule Luta.ETS do
  @moduledoc """
  The module responsable for ETS
  """

  def start_table(arena_id) do
    :ets.new(Utils.combat_atom(arena_id), [:set, :named_table, :public])
  end

  def delete_table(arena_id) do
    :ets.delete(Utils.combat_atom(arena_id))
  end

  def insert_scena(table, content) do
    :ets.insert(table, {:scena, content})
  end

  def lookup_scena(table) do
    :ets.lookup(table, :scena)[:scena]
  end
end
