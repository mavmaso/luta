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
      params = %{name: "test"}

      conn =
        login(conn, p1)
        |> post(Routes.arena_path(conn, :create, params))

      assert %{"arena" => subject} = json_response(conn, 201)["data"]
      assert subject["status"] == "open"
      assert subject["p1_id"] == p1.id
    end
  end

  describe "show" do
    test "a arena. Returns :ok", %{conn: conn} do
      p1 = insert(:user)
      arena = insert(:arena)
      params = %{arena_id: arena.id}

      conn =
        login(conn, p1)
        |>get(Routes.arena_path(conn, :show, params))

      assert %{"arena" => subject} = json_response(conn, 200)["data"]
      assert subject["id"] == arena.id
    end
  end

  describe "delete" do
    test "a arena. Returns :ok", %{conn: conn} do
      p1 = insert(:user)
      arena = insert(:arena)

      conn =
        login(conn, p1)
        |> delete(Routes.arena_path(conn, :delete, arena.id))

      assert json_response(conn, 200)
      assert_raise Ecto.NoResultsError, fn -> Luta.Battle.get_arena!(arena.id) end
    end
  end

  describe "select_char" do
    test "p2 entry in a arena with a fighter. Returns :ok", %{conn: conn} do
      p2 = insert(:user)
      char2 = insert(:fighter)
      arena = insert(:arena, %{p2: p2, char2: nil})
      params = %{char2_id: char2.id, id: arena.id}

      conn =
        login(conn, p2)
        |> put(Routes.arena_path(conn, :select_char, params))

      assert %{"arena" => x_arena} = json_response(conn, 200)["data"]
      assert x_arena["char2_id"] == params.char2_id
    end

    test "p1 entry in a arena with a fighter. Returns :ok", %{conn: conn} do
      p1 = insert(:user)
      char1 = insert(:fighter)
      arena = insert(:arena, %{p1: p1, char1: nil})
      params = %{char1_id: char1.id, id: arena.id}

      conn =
        login(conn, p1)
        |> put(Routes.arena_path(conn, :select_char, params))

      assert %{"arena" => x_arena} = json_response(conn, 200)["data"]
      assert x_arena["char1_id"] == params.char1_id
    end
  end

  describe "join arena" do
    test "player2 enter in an open arena. Returns :ok", %{conn: conn} do
      p2 = insert(:user)
      arena = insert(:arena, %{p2: nil, status: "open"})
      params = %{arena_id: arena.id}

      conn =
        login(conn, p2)
        |> put(Routes.arena_path(conn, :join_arena, params))

      assert %{"arena" => x_arena} = json_response(conn, 200)["data"]
      assert x_arena["id"] == params.arena_id
      assert x_arena["p2_id"] == p2.id
    end
  end
end
