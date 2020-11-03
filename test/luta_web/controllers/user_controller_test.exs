defmodule LutaWeb.UserControllerTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "w/ user and returns it self and jwt w/ status :ok", %{conn: conn} do
      params = %{user: %{login: "algo", password: "123456"}}

      conn = post(conn, Routes.user_path(conn, :create, params))

      assert subject = json_response(conn, 201)["data"]
      assert subject["user"]["login"] == params.user.login
      assert subject["jwt"] =~ "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9"
    end
  end

  describe "sign_in" do
    test "a user, returns status :ok", %{conn: conn} do
      user = insert(:user)
      params = %{login: user.login, password: "123456"}

      conn = post(conn, Routes.user_path(conn, :sign_in, params))
      jwt = json_response(conn, 200)["data"]["jwt"]
      assert jwt =~ "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9"
    end

    test "can't invalid password, returns 400", %{conn: conn} do
      user = insert(:user)
      params = %{login: user.login, password: "errado"}

      conn = post(conn, Routes.user_path(conn, :sign_in, params))

      assert %{"detail" => "Unauthorized"} = json_response(conn, 401)["errors"]
    end

    # test "can't invalid login, returns 400", %{conn: conn} do

    # end
  end

  describe "show" do

  end
end
