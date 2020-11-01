defmodule LutaWeb.ArenaController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle

  # action_fallback LutaWeb.FallbackController

  def index(conn, _params) do
    arenas = Battle.list_arenas() |> IO.inspect
    json(conn, %{data: arenas})
  end
end
