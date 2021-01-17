defmodule Luta.FullFightSpecTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  alias Luta.Combat

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

  defp send_card(conn, arena_id, card_id, player) do
    params = %{arena_id: arena_id, action_id: card_id}

    login(conn, player) |> post(Routes.combat_path(conn, :actions, params))
  end

  describe "A Fight" do
    @tag :fight
    test "when flow :duel", %{conn: conn, p1: p1, p2: p2} = context do
      arena = Luta.Combat.start(context.arena)
      action = insert(:move_set, %{power: 10})

      send_card(conn, arena.id, action.id, p1)
      send_card(conn, arena.id, action.id, p2)

      conn =
        login(conn, p1)
        |> get(Routes.combat_path(conn, :sync, arena.id))

      assert subject = json_response(conn, 200)["data"]["info"]
      assert subject["scena"] == 0
      assert subject["buffer_1_size"] == 1

      Process.sleep(1505)

      conn =
        login(context.conn, context.p1)
        |> get(Routes.combat_path(context.conn, :sync, arena.id))

      assert subject = json_response(conn, 200)["data"]["info"]
      assert subject["scena"] == 1
      assert subject["buffer_1_size"] == 0
      # assert subject["p1"]["hps"] == context.c1.hps
      # assert subject["p2"]["hps"] == context.c2.hps
    end
  end
end
