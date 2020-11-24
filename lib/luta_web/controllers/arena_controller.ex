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
    args = params |> Map.merge(%{"p1_id" => get_current_user(conn).id, "status" => "open"})
    {:ok, arena} = Battle.create_arena(args)
    put_status(conn, :created) |> json(%{data: %{arena: arena}})
  end

  def show(conn, params) do
    arena = Battle.get_arena!(params["arena_id"])
    json(conn, %{data: %{arena: arena}})
  end

  def delete(conn, params) do
    with arena <- Battle.get_arena!(params["id"]),
    {:ok, _} <- Battle.delete_arena(arena) do
      json(conn, %{data: "successfull deleted"})
    end
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

  def select_char(conn, %{"char1_id" => _} = params) do
    with  %Auth.User{} = player <- get_current_user(conn),
    %Battle.Arena{} = arena <- Battle.get_arena!(params["id"]),
    %Char.Fighter{} = char <- Char.get_fighter!(params["char1_id"]) do

      case player.id == arena.p1_id do
        true ->

          {:ok, new_arena} = Battle.update_arena(arena, %{char1_id: char.id})
          json(conn, %{data: %{arena: new_arena}})
        false ->
          {:error, :unauthorized}
      end

    end

  end

  def join_arena(conn, params) do
    with %Battle.Arena{status: "open"} = arena <- Battle.get_arena!(params["arena_id"]),
      %Auth.User{} = player <- get_current_user(conn) do

        {:ok, new_arena} = Battle.update_arena(arena, %{p2_id: player.id})
        json(conn, %{data: %{arena: new_arena}})
      end
    end
end
