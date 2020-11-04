defmodule Luta.TestHelpers do
  import Plug.Conn

  def login(conn, user) do
    {:ok, jwt, _claims} = Luta.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{jwt}")

    conn
  end
end
