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

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :start, params))

      assert %{"arena" => x_arena} = json_response(conn, 200)["data"]
      assert x_arena["status"] == "fighting"
      assert Battle.get_arena!(context.arena.id).status == "fighting"

      assert [p1: x_p1] = :ets.lookup(String.to_atom("arena@#{context.arena.id}"), :p1)
      assert x_p1.char.id == context.arena.char1.id
      assert x_p1.id == context.arena.p1.id
      assert x_p1.status == "normal"

      assert [p2: x_p2] = :ets.lookup(String.to_atom("arena@#{context.arena.id}"), :p2)
      assert x_p2.char.id == context.arena.char2.id
      assert x_p2.id == context.arena.p2.id
      assert x_p2.status == "normal"

      assert :ets.delete(String.to_atom("arena@#{context.arena.id}"))
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
      action = %{size: 1, description: "soco", power: 1, special: nil}
      params = %{arena_id: arena.id, action: action}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params))

      assert %{"list" => [x_first], "size" => _} = json_response(conn, 200)["data"]["queue"]

      action_two = %{size: 2, description: "katanada pesada", power: 5, special: nil}
      params_two = %{arena_id: arena.id, action: action_two}

      conn =
        login(context.conn, context.p1)
        |> post(Routes.combat_path(context.conn, :actions, params_two))

      assert subject = json_response(conn, 200)["data"]["queue"]
      assert subject["size"] == action.size + action_two.size
      assert [^x_first, x_secound] = subject["list"]
    end
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
