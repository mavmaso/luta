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
      p1: p1, c1: c1,
      p2: p2, c2: c2,
      arena: arena
    }
  end

  describe "start" do
    test "a battle w/ 2 player all setup, Returns :ok", context do
      params = %{arena_id: context.arena.id}
      combat = Utils.combat_atom(context.arena.id)

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :start, params))

      assert %{"arena" => x_arena} = json_response(conn, 200)["data"]
      assert x_arena["status"] == "fighting"
      assert Battle.get_arena!(context.arena.id).status == "fighting"

      assert [p1: x_p1] = :ets.lookup(combat, :p1)
      assert x_p1.char.id == context.arena.char1.id
      assert x_p1.id == context.arena.p1.id
      assert x_p1.status == "normal"

      assert [p2: x_p2] = :ets.lookup(combat, :p2)
      assert x_p2.char.id == context.arena.char2.id
      assert x_p2.id == context.arena.p2.id
      assert x_p2.status == "normal"

      assert :ets.lookup(combat, :scena)[:scena] == 0
      assert :ets.delete(combat)
    end

    test "Can't when arena is not waiting. Returns :error", context do
      arena = insert(:arena, %{status: "pending"})
      params = %{arena_id: arena.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :start, params))

      assert %{"message" => "not_ready"} = json_response(conn, 400)["error"]
    end
  end

  describe "actions" do
    test "p1 send two separed actions. Returns :ok", context do
      arena = Luta.Combat.start(context.arena)
      action = insert(:move_set)
      params = %{arena_id: arena.id, action_id: action.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params))

      assert %{"list" => [x_first], "size" => _} = json_response(conn, 200)["data"]["buffer"]

      action_two = insert(:move_set, %{size: 3})
      params_two = %{arena_id: arena.id, action_id: action_two.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params_two))

      assert subject = json_response(conn, 200)["data"]["buffer"]
      assert subject["size"] == action.size + action_two.size
      assert [^x_first, _x_secound] = subject["list"]
    end
  end

  describe "sync" do
    test "p1 request info about combat. Returns :ok", context do
      arena = Luta.Combat.start(context.arena)

      conn =
        login(context.conn, context.p1)
        |> get(Routes.combat_path(context.conn, :sync, arena.id))

      assert subject = json_response(conn, 200)["data"]
      assert subject["arena"]["id"] == arena.id
      assert subject["arena"]["status"] == arena.status
      assert subject["info"]["scena"] == 0

      assert subject["info"]["p1"]["char"]["hps"] |> is_integer()
      assert subject["info"]["buffer_1"] == 0

      assert subject["info"]["p2"]["char"]["hps"] |> is_integer()
      assert subject["info"]["buffer_2"] == 0

      assert :ets.delete(Utils.combat_atom(arena.id))
    end
  end

  describe "run_buffer" do
    @tag :heavy
    test "check first scena's results", context do
      # combat = Utils.combat_atom(context.arena.id)
      arena = Luta.Combat.start(context.arena)
      action = insert(:move_set)
      params = %{arena_id: arena.id, action_id: action.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params))

      conn = post(conn, Routes.combat_path(context.conn, :actions, params))

      assert %{"size" => buffer_size} = json_response(conn, 200)["data"]["buffer"]

      # :timer.sleep(3010)
      Process.sleep(3010)
      conn =
        login(context.conn, context.p1)
        |> get(Routes.combat_path(context.conn, :sync, arena.id))

      assert subject = json_response(conn, 200)["data"]
      # IO.inspect subject
      assert subject["info"]["scena"] == 1
      assert subject["info"]["buffer_1_size"] == buffer_size - action.size
      # assert subject["info"]["p2"]["hps"] == 100 - action.power
    end
  end

  describe "proc" do

  end

  describe "forfeit" do
    @tag :skip
    test "a battle w/2 players. Returns :ok", context do
      arena = Luta.Combat.start(context.arena)
      params = %{arena_id: arena.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :forfeit, params))

      assert %{"arena" => subject} = json_response(conn, 200)["data"]
      assert subject["status"] == "closed"
      assert false == :ets.delete(Utils.combat_atom(arena.id))
    end
  end

  describe "close" do

  end
end
