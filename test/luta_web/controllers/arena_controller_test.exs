defmodule LutaWeb.ArenaControllerTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "list all arenas", %{conn: conn} do
      arena = insert(:arena)

      conn = get(conn, Routes.arena_path(conn, :index))

      assert [subject] = json_response(conn, 200)["data"]
      assert subject["name"] == arena.name
    end
  end
end
