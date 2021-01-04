defmodule LutaWeb.CombatSpecTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  alias Luta.{Battle, ETS}

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

      assert x_p1 = ETS.lookup(combat, "p1")
      assert x_p1.char_id == context.arena.char1.id
      assert x_p1.id == context.arena.p1.id
      assert x_p1.status == ["normal"]

      assert x_p2 = ETS.lookup(combat, "p2")
      assert x_p2.char_id == context.arena.char2.id
      assert x_p2.id == context.arena.p2.id
      assert x_p2.status == ["normal"]

      assert ETS.lookup(combat, "scena") == 0
      assert ETS.delete_table(context.arena.id)
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

      assert [_x_first] = json_response(conn, 200)["data"]["buffer"]

      action_two = insert(:move_set)
      params_two = %{arena_id: arena.id, action_id: action_two.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params_two))

      assert subject = json_response(conn, 200)["data"]["buffer"]
      assert subject |> length() == 2
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
      assert subject["info"]["narrator"]

      assert subject["info"]["p1"]["hps"] |> is_integer()
      assert subject["info"]["buffer_1_size"] == 0

      assert subject["info"]["p2"]["hps"] |> is_integer()
      assert subject["info"]["buffer_2_size"] == 0

      assert ETS.delete_table(arena.id)
    end
  end

  describe "run_buffer" do
    @tag :heavy
    test "check secound scena's results", context do
      # combat = Utils.combat_atom(context.arena.id)
      arena = Luta.Combat.start(context.arena)
      action = insert(:move_set, %{power: 10})
      params = %{arena_id: arena.id, action_id: action.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params))

      conn = post(conn, Routes.combat_path(context.conn, :actions, params))

      assert x_list = json_response(conn, 200)["data"]["buffer"]

      Process.sleep(1505)

      action_2 = insert(:move_set, %{type: "A", special: "blocking", power: 0})
      params_2 = %{arena_id: arena.id, action_id: action_2.id}

      conn =
        login(context.conn, context.p2)
        |> post(Routes.combat_path(context.conn, :actions, params_2))

      assert %{"type" => "A"} = json_response(conn, 200)["data"]["buffer"] |> hd

      Process.sleep(1505)

      conn =
        login(context.conn, context.p1)
        |> get(Routes.combat_path(context.conn, :sync, arena.id))

      assert subject = json_response(conn, 200)["data"]
      assert subject["info"]["scena"] == 2
      assert subject["info"]["buffer_1_size"] == (x_list |> length()) - 2
      assert subject["info"]["p2"]["hps"] == 100 - ((context.c1.atk + action.power) - 10)
      assert subject["info"]["p1"]["hps"] == context.c1.hps
    end
  end

  describe "proc" do

  end

  describe "forfeit" do
    test "a battle w/2 players. as a P1 Returns :ok", context do
      arena = Luta.Combat.start(context.arena)
      params = %{arena_id: arena.id}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :forfeit, params))

      assert %{"arena" => subject} = json_response(conn, 200)["data"]
      assert subject["status"] == "closed"
      assert_raise ArgumentError, fn -> ETS.delete_table(arena.id) end
    end
  end

  describe "close" do

  end
end
