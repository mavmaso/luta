defmodule LutaWeb.CombatSpecTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  alias Luta.Battle

  setup %{conn: conn} do
    p1 = insert(:user)
    c1 = insert(:fighter)
    p2 = insert(:user)
    c2 = insert(:fighter)
  arena = insert(:arena, %{p1: p1, p2: p2, char1: c1, char2: c2, status: "waiting"})

    {
      :ok,
      conn: put_req_header(conn, "accept", "application/json"),
      p1: p1,
      p2: p2,
      arena: arena
    }
  end

  describe "start" do
    test "a battle w/ 2 player all setup", context do
      params = %{arena_id: context.arena.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :start, params))

      assert json_response(conn, 200)
      assert Battle.get_arena!(context.arena.id).status == "fighting"
      assert [p1: x_p1] = :ets.lookup(String.to_atom("arena@#{context.arena.id}"), :p1)
      assert [p2: x_p2] = :ets.lookup(String.to_atom("arena@#{context.arena.id}"), :p2)
    end

    test "Can't start when arena is not waiting" do

    end
  end

  describe "action" do

  end

  describe "sync" do

  end

  describe "queue" do

  end

  describe "proc" do

  end

  describe "forfeit" do

  end

  describe "close" do

  end
end
