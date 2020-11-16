defmodule LutaWeb.CombatController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle
  alias Utils
  alias Luta.Combat
  alias Luta.Guardian.Plug

  action_fallback LutaWeb.FallbackController

  def start(conn, params) do
    with %Battle.Arena{} = arena <- Battle.get_arena!(params["arena_id"]),
     {:ok, _} <- Battle.check_arena(arena, "waiting") do
      arena = Combat.start(arena)
      json(conn, %{data: %{arena: arena}})
    end
  end

  def actions(conn, params) do
    args = Utils.atomify_map(params)
    with %Battle.Arena{} = arena <- Battle.get_arena!(args.arena_id),
      {:ok, _} <- Battle.check_arena(arena, "fighting") do

      current_user = Plug.current_resource(conn)
      case Combat.actions(arena.id, current_user.id, args.action) do
        {:ok, new_queue} -> json(conn, %{data: %{queue: new_queue}})
        _ -> {:error, :cant_insert}
      end
    end
  end
end
