defmodule LutaWeb.UserController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.{Auth, Guardian}

  # action_fallback LutaWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %Auth.User{} = user} <- Auth.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      # conn |> render("jwt.json", jwt: token)
      json(conn, %{data: %{jwt: token, user: user}})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    json(conn, %{data: %{user: user}})
  end
end
