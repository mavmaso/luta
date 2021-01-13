defmodule Luta.ProgressTest do
  use Luta.DataCase

  import Luta.Factory

  alias Luta.Progress

  alias Luta.Progress.Profile

  describe "profiles" do
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
      assert profile.defeats == params.defeats
      assert profile.matches == params.matches
      assert profile.season == params.season
      assert profile.victories == params.victories
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

  describe "battle_record/3" do
     test "when valid data, returns :ok" do
      arena = insert(:arena)
      profile_a = insert(:profile, %{victories: 0, defeats: 0, matches: 0})
      profile_b = insert(:profile, %{victories: 0, defeats: 0, matches: 0})

      assert :ok = Progress.battle_record(arena, profile_a.user, profile_b.user)

      assert %Profile{victories: 1, matches: 1} = Progress.get_profile!(profile_a.id)
      assert %Profile{defeats: 1, matches: 1} = Progress.get_profile!(profile_b.id)
     end
  end
end
