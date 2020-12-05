defmodule Luta.CombatServerTest do
  use Luta.DataCase

  # import Luta.Factory

  # alias Luta.CombatServer

  # test "start_link/1 two servers w/ differents pid" do
  #   arena = insert(:arena)
  #   arena_b = insert(:arena)
  #   Luta.Combat.start(arena)
  #   Luta.Combat.start(arena_b)

  #   assert {:ok, pid} = CombatServer.start_link(arena.id)
  #   assert {:ok, pid_two} = CombatServer.start_link(arena_b.id)
  #   assert pid != pid_two

  #   combat = "arena@#{arena.id}"
  #   scena = :ets.lookup(combat, :scena)[:scena]
  #   assert scena = 1
  # end

  # test "stop/1" do
  #   arena = insert(:arena)

  #   assert {:ok, pid} = CombatServer.start_link(arena.id)
  #   assert CombatServer.stop(pid)
  #   # assert false = Process.alive?(pid)
  # end
end
