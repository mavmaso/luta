defmodule Luta.FullFightSpecTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  alias Luta.Combat

  setup %{conn: conn} do
    p1 = insert(:user)
    c1 = insert(:fighter)
    p2 = insert(:user)
    arena = insert(:arena, %{p1: p1, p2: p2, char1: c1, char2: c1, status: "waiting"})

    {
      :ok,
      conn: put_req_header(conn, "accept", "application/json"),
      p1: p1, c1: c1, p2: p2,
      arena: arena
    }
  end

  defp send_card(conn, arena_id, card_id, player) do
    params = %{arena_id: arena_id, action_id: card_id}

    login(conn, player) |> post(Routes.combat_path(conn, :actions, params))
  end

  defp sync(conn, arena_id) do
    get(conn, Routes.combat_path(conn, :sync, arena_id))
  end

  describe "A Fight" do
    @tag :fight
    test "when flow :duel", %{p1: p1, p2: p2} = context do
      char = insert(:fighter, %{hps: 12})
      arena = insert(:arena, %{p1: p1, p2: p2, char1: char, char2: char, status: "waiting"})
      arena = Combat.start(arena)
      action = insert(:move_set, %{power: 10})

      send_card(context.conn, arena.id, action.id, p1)
      send_card(context.conn, arena.id, action.id, p2)
      conn = sync(context.conn, arena.id)

      assert subject = json_response(conn, 200)["data"]["info"]
      assert subject["scena"] == 0
      assert subject["buffer_1_size"] == 1
      assert subject["buffer_2_size"] == 1

      Process.sleep(1505)
      conn = sync(context.conn, arena.id)

      assert subject = json_response(conn, 200)["data"]["info"]
      assert subject["scena"] == 1
      assert subject["buffer_1_size"] == 0

      assert subject["p1"]["hps"] == char.hps - (action.power + char.atk)

      assert subject["p2"]["hps"] == char.hps - (action.power + char.atk)

      Process.sleep(1505)

      send_card(context.conn, arena.id, action.id, p2)
      Process.sleep(1505)
      conn = sync(conn, arena.id)

      assert subject = json_response(conn, 200)["data"]["info"]
      assert subject["scena"] == 3
      assert subject["buffer_2_size"] == 0
      assert subject["p1"]["hps"] < 0

      assert x_arena = json_response(conn, 200)["data"]["arena"]
      assert x_arena["status"] == "closed"
      assert x_arena["winner"] == p2.nick
    end
  end
end
