defmodule LutaWeb.UserControllerTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "a user and returns it self and jwt w/ status :ok", %{conn: conn} do
      params = %{user: %{login: "algo", password: "123456"}}

      conn = post(conn, Routes.user_path(conn, :create, params))

      assert subject = json_response(conn, 200)["data"]
      assert subject["user"]["login"] == params.user.login
      assert subject["jwt"] =~ "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9"
    end
  end

  describe "show" do
    # test "a user and returns it self w/ status :ok", %{conn: conn} do
      # $2b$12$vgSMx4niK.IwyMgxLjDtw.klWMat6O9vkZH5SDlesaoSUCePC9n5S
    # end
  end
end
