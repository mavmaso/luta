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

  describe "select_char" do
    test "p2 entry in a arena with a fighter. Returns :ok", %{conn: conn} do
      p2 = insert(:user)
      char2 = insert(:fighter)
      arena = insert(:arena, %{p2: p2, char2: nil})
      params = %{char2_id: char2.id}

      conn =
        login(conn, p2)
        |> put(Routes.arena_path(conn, :select_char, id: arena.id), params)

      assert %{"arena" => x_arena} = json_response(conn, 200)["data"]
      assert x_arena["char2_id"] == params.char2_id
    end
  end
end
