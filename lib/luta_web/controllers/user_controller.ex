defmodule LutaWeb.UserController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.{Auth, Guardian}

  action_fallback LutaWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %Auth.User{} = user} <- Auth.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn |> put_status(:created) |>json(%{data: %{jwt: token, user: user}})
    end
  end

  def sign_in(conn, %{"login" => login, "password" => password}) do
    with {:ok, token, _claims} <- Auth.token_sign_in(login, password) do
      conn |> json(%{data: %{jwt: token}})
    else
      _ -> conn |> json(%{error: "unauthorized"})
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    json(conn, %{data: %{user: user}})
  end
end
