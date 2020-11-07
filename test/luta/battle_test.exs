defmodule Luta.BattleTest do
  use Luta.DataCase

  import Luta.Factory

  alias Luta.Battle

  describe "arenas" do
    alias Luta.Battle.Arena

    test "list_arenas/0 returns all arenas" do
      arena = insert(:arena)

      assert [subject] = Battle.list_arenas()
      assert subject.name == arena.name
    end

    test "get_arena!/1 returns the arena with given id" do
      arena = insert(:arena)

      assert subject = Battle.get_arena!(arena.id)
      assert subject.id == arena.id
      assert subject.name == arena.name
    end

    test "create_arena/1 with valid data creates a arena" do
      p1 = insert(:user)
      p2 = insert(:user)
      params = params_for(:arena, %{p1_id: p1.id, p2_id: p2.id})

      assert {:ok, %Arena{} = subject} = Battle.create_arena(params)
      assert subject.name == params.name
      assert subject.status == params.status
      assert subject.p1_id == params.p1_id
      assert subject.p2_id == params.p2_id
    end

    test "create_arena/1 with invalid data returns error changeset" do
      params = %{name: "oi"}

      assert {:error, %Ecto.Changeset{}} = Battle.create_arena(params)
    end

    test "update_arena/2 with valid data updates the arena" do
      arena = insert(:arena)
      params = params_for(:arena)

      assert {:ok, %Arena{} = subject} = Battle.update_arena(arena, params)
      assert subject.name == params.name
    end

    test "update_arena/2 with invalid data returns error changeset" do
      arena = insert(:arena)
      params = %{name: "oi"}

      assert {:error, %Ecto.Changeset{}} = Battle.update_arena(arena, params)
    end

    test "delete_arena/1 deletes the arena" do
      arena = insert(:arena)

      assert {:ok, %Arena{}} = Battle.delete_arena(arena)
      assert_raise Ecto.NoResultsError, fn -> Battle.get_arena!(arena.id) end
    end
  end
end
