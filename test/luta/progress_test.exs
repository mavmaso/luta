defmodule Luta.ProgressTest do
  use Luta.DataCase

  import Luta.Factory

  alias Luta.Progress

  describe "profiles" do
    alias Luta.Progress.Profile

    test "list_profiles/0 returns all profiles" do
      profile = insert(:profile)

      assert [subject] = Progress.list_profiles()
      assert subject.id == profile.id
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = insert(:profile)

      assert subject =  Progress.get_profile!(profile.id)
      assert subject.id == profile.id
    end

    test "create_profile/1 with valid data creates a profile" do
      profile = insert(:profile)
      params = %{matches: 40, victories: 10, defeats: 15, season: "2020-season"}

      assert {:ok, %Profile{} = profile} = Progress.create_profile(params)
      assert profile.defeats == params.defeats
      assert profile.matches == params.matches
      assert profile.season == params.season
      assert profile.victories == params.victories
    end

    # test "create_profile/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Progress.create_profile(@invalid_attrs)
    # end

    test "update_profile/2 with valid data updates the profile" do
      profile = insert(:profile)
      params = params_for(:profile)

      assert {:ok, %Profile{} = profile} = Progress.update_profile(profile, params)
      assert profile.defeats == 43
      assert profile.matches == 43
      assert profile.season == "some updated season"
      assert profile.victories == 43
    end

    # test "update_profile/2 with invalid data returns error changeset" do
    #   profile = insert(:profile)
    #   assert {:error, %Ecto.Changeset{}} = Progress.update_profile(profile, @invalid_attrs)
    #   assert profile == Progress.get_profile!(profile.id)
    # end

    test "delete_profile/1 deletes the profile" do
      profile = insert(:profile)
      assert {:ok, %Profile{}} = Progress.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Progress.get_profile!(profile.id) end
    end
  end
end
