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
    {
    :ok, arena} = Battle.create_arena(params)
    json(conn, %{data: arena})
  end

  def select_char(conn, %{"char2_id" => _} = params) do
    with %Auth.User{} =  player <- get_current_user(conn),
      %Battle.Arena{} = arena <- Battle.get_arena!(params["id"]),
      %Char.Fighter{} = char <- Char.get_fighter!(params["char2_id"]) do

      case player.id == arena.p2_id do
        true ->
          {:ok, new_arena} = Battle.update_arena(arena, %{char2_id: char.id})
          json(conn, %{data: %{arena: new_arena}})
        false ->
          {:error, :unauthorized}
      end
    end
  end
end
