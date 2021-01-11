defmodule LutaWeb.UserControllerTest do
  use LutaWeb.ConnCase

  import Luta.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up" do
    test "w/ user and returns it self and jwt w/ status :ok", %{conn: conn} do
      params = %{user: params_for(:user, %{password: "somepassword"})}

      conn = post(conn, Routes.user_path(conn, :create, params))

      assert subject = json_response(conn, 201)["data"]
      assert subject["user"]["login"] == params.user.login
      assert subject["jwt"] =~ "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9"
    end
  end

  describe "login" do
    test "a user, returns status :ok", %{conn: conn} do
      user = insert(:user)
      params = %{login: user.login, password: "somepassword"}

      conn = post(conn, Routes.user_path(conn, :login, params))
      jwt = json_response(conn, 200)["data"]["jwt"]
      assert jwt =~ "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9"
    end

    test "can't invalid password, returns 400", %{conn: conn} do
      user = insert(:user)
      params = %{login: user.login, password: "errado"}

      conn = post(conn, Routes.user_path(conn, :login, params))

      assert %{"detail" => "Unauthorized"} = json_response(conn, 401)["errors"]
    end
  end

  describe "show" do
    test "renders a my user, status :ok", %{conn: conn} do
      user = insert(:user)

      conn =
        login(conn, user)
        |> get(Routes.user_path(conn, :show))

      assert subject = json_response(conn, 200)
      assert subject["id"] == user.id
      assert subject["login"] == user.login
    end
  end
end
