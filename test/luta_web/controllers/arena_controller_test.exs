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

  describe "create" do
    test "a arena w/ only p1. Returns :ok", %{conn: conn} do
      p1 = insert(:user)
      params = %{
        name: "test",
        p1_id: p1.id,
      }

      conn =
        login(conn, p1)
        |> post(Routes.arena_path(conn, :create, params))

      assert subject = json_response(conn, 200)["data"]
      assert subject["p1_id"] == p1.id
      assert subject["status"] == "pending"
    end
  end
end
