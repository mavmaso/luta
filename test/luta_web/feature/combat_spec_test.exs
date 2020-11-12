defmodule LutaWeb.CombatSpecTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  alias Luta.Battle

  setup %{conn: conn} do
    p1 = insert(:user)
    p2 = insert(:user)
    arena = insert(:arena, %{p1: p1, p2: p2, status: "waiting"})

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

      assert json_response(conn, 200) |> IO.inspect
      assert Battle.get_arena!(context.arena.id).status == "fighting"
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
