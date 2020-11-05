defmodule LutaWeb.ArenaController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle

  action_fallback LutaWeb.FallbackController

  def index(conn, _params) do
    arenas = Battle.list_arenas()
    json(conn, %{data: arenas})
  end

  def create(conn, params) do
    {:ok, arena} = Battle.create_arena(params)
    json(conn, %{data: arena})
  end
end
