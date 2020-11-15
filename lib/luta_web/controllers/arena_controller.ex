defmodule LutaWeb.ArenaController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  import Utils

  alias Luta.{Battle, Auth, Char}

  action_fallback LutaWeb.FallbackController

  def index(conn, _params) do
    arenas = Battle.list_arenas()
    json(conn, %{data: arenas})
  end

  def create(conn, params) do
    {:ok, arena} = Battle.create_arena(params)
    json(conn, %{data: arena})
  end

  def select_char(conn, params) do
    with %Auth.User{} =  player <- get_current_user(conn),
      %Battle.Arena{} = arena <- Battle.get_arena!(params["id"]),
      %Char.Fighter{} = char <- Char.get_fighter!(params["char2_id"]) do
      [player, arena, char]

      json(conn, %{data: "WIP"})
    else
      _ -> {:error, :not_yet}
    end
  end
end
