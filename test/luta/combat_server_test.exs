defmodule Luta.CombatServerTest do
  use Luta.DataCase

  import Luta.Factory

  alias Luta.CombatServer

  test "Start two servers w/ differents pid" do
    arena = insert(:arena)

    assert {:ok, pid} = CombatServer.start_link(arena.id)
    assert {:ok, pid_two} = CombatServer.start_link(arena.id)
    assert pid != pid_two
  end
end
