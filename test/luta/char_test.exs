defmodule Luta.CharTest do
  use Luta.DataCase
  import Luta.Factory
  alias Luta.Char

  describe "fighters" do
    alias Luta.Char.Fighter


    test "list_fighters/0 returns all fighters" do
      fighter = insert(:fighter)

      assert [subject] = Char.list_fighters()
      assert subject.id == fighter.id
    end

    test "get_fighter!/1 returns the fighter with given id" do
      fighter = insert(:fighter)

      assert subject = Char.get_fighter!(fighter.id)
      assert subject.id == fighter.id
    end

    test "create_fighter/1 with valid data creates a fighter" do
      params = params_for(:fighter)

      assert {:ok, %Fighter{} = subject} = Char.create_fighter(params)
      assert subject.atk == params.atk
      assert subject.def == params.def
      assert subject.hps == params.hps
      assert subject.spd == params.spd
      assert subject.title == params.title
    end

    # test "create_fighter/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Char.create_fighter()
    # end

    test "update_fighter/2 with valid data updates the fighter" do
      fighter = insert(:fighter)
      params = params_for(:fighter)

      assert {:ok, %Fighter{} = fighter} = Char.update_fighter(fighter, params)
      assert fighter.atk == params.atk
      assert fighter.def == params.def
      assert fighter.hps == params.hps
      assert fighter.spd == params.spd
      assert fighter.title == params.title
    end

    # test "update_fighter/2 with invalid data returns error changeset" do
    #   fighter = insert(:fighter)
    #   assert {:error, %Ecto.Changeset{}} = Char.update_fighter(fighter, @invalid_attrs)
    #   assert fighter == Char.get_fighter!(fighter.id)
    # end

    test "delete_fighter/1 deletes the fighter" do
      fighter = insert(:fighter)

      assert {:ok, %Fighter{}} = Char.delete_fighter(fighter)
      assert_raise Ecto.NoResultsError, fn -> Char.get_fighter!(fighter.id) end
    end

  end
end
