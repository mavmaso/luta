defmodule Luta.AuthTest do
  use Luta.DataCase

  import Luta.Factory

  alias Luta.Auth

  describe "users" do
    alias Luta.Auth.User

    test "list_users/0 returns all users" do
      user = insert(:user)

      assert [subject] = Auth.list_users()
      assert subject.login == user.login
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)

      assert subject = Auth.get_user!(user.id)
      assert subject.login == user.login
    end

    test "create_user/1 with valid data creates a user" do
      params = params_for(:user, %{password: "123456"})

      assert {:ok, %User{} = user} = Auth.create_user(params)
      assert user.login == params.login
      # assert user.password == params.password
    end

    test "create_user/1 with invalid data returns error changeset" do
      insert(:user, %{login: "usei"})
      params = params_for(:user, %{login: "usei"})

      assert {:error, %Ecto.Changeset{}} = Auth.create_user(params)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      params = params_for(:user)

      assert {:ok, %User{} = user} = Auth.update_user(user, params)
      assert user.login == params.login
      # assert user.password == params.password
    end

    # test "update_user/2 with invalid data returns error changeset" do
    #   user = insert(:user)
    #   params = params_for(:user, %{password: "usei"})

    #   assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, params)
    # end

    test "delete_user/1 deletes the user" do
      user = insert(:user)

      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end
  end
end
