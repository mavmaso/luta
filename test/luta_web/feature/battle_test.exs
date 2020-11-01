defmodule LutaWeb.BattleTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Battle" do
    test "commence a fight w/ 2 player", %{conn: conn} do
      arena = insert(:arena)
      p1 = %{name: "Red"}
      action = %{command: "D", card: %{name: "katana", atk: 10}}
      # p2 = %{name: "Green"}

      params = %{arena_id: arena.id, player: p1, action: action}

      conn = post(conn, Routes.battle_path(conn, :battle, params))

      # json_response(conn, 200) |> IO.inspect
      assert subject = json_response(conn, 200)["data"]
      assert subject["scene"] |> hd |> Map.get("msg") =~ p1.name
      assert subject["scene"] |> hd |> Map.get("msg") =~ action.card.name
    end
  end
end
