defmodule Luta.CardsTest do
  use Luta.DataCase

  alias Luta.Cards

  import Luta.Factory

  describe "move_sets" do
    alias Luta.Cards.MoveSet

    test "list_move_sets/0 returns all move_sets" do
      move_set = insert(:move_set)

      assert [subject] = Cards.list_move_sets()
      assert subject.type == move_set.type
    end

    test "get_move_set!/1 returns the move_set with given id" do
      move_set = insert(:move_set)

      assert subject = Cards.get_move_set!(move_set.id)
      assert subject.type == move_set.type
    end

    test "create_move_set/1 with valid data creates a move_set" do
      params = params_for(:move_set)

      assert {:ok, %MoveSet{} = subject} = Cards.create_move_set(params)
      assert subject.description == params.description
      assert subject.power == params.power
      assert subject.size == params.size
      assert subject.special == params.special
      assert subject.type == params.type
    end

    # test "create_move_set/1 with invalid data returns error changeset" do
    #   params = params_for(:move_set)

    #   assert {:error, %Ecto.Changeset{}} = Cards.create_move_set(params)
    # end

    test "update_move_set/2 with valid data updates the move_set" do
      move_set = insert(:move_set)
      params = params_for(:move_set)

      assert {:ok, %MoveSet{} = subject} = Cards.update_move_set(move_set, params)
      assert subject.description == params.description
      assert subject.power == params.power
      assert subject.size == params.size
      assert subject.special == params.special
      assert subject.type == params.type
    end

    # test "update_move_set/2 with invalid data returns error changeset" do
    #   params = params_for(:move_set)

    #   move_set = insert(:move_set)
    #   assert {:error, %Ecto.Changeset{}} = Cards.update_move_set(move_set, params)
    #   assert move_set == Cards.get_move_set!(move_set.id)
    # end

    test "delete_move_set/1 deletes the move_set" do
      move_set = insert(:move_set)

      assert {:ok, %MoveSet{}} = Cards.delete_move_set(move_set)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_move_set!(move_set.id) end
    end

    test "change_move_set/1 returns a move_set changeset" do
      move_set = insert(:move_set)
      assert %Ecto.Changeset{} = Cards.change_move_set(move_set)
    end
  end
end
