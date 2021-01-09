defmodule LutaWeb.ProfileControllerTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "list all profiles by season", %{conn: conn} do
      profile = insert(:profile, %{season: "1"})
      insert(:profile, %{season: "1"})
      insert(:profile, %{season: "2"})

      conn = get(conn, Routes.profile_path(conn, :index, profile.season))

      assert [subject, _] = json_response(conn, 200)["data"]["profiles"]
      assert subject["season"] == profile.season
    end
  end
end
