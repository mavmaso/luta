defmodule LutaWeb.CombatController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Utils
  alias Luta.{Battle, Combat, Cards}
  alias Luta.Guardian.Plug

  action_fallback LutaWeb.FallbackController

  def start(conn, params) do
    with %Battle.Arena{} = arena <- Battle.get_arena!(params["arena_id"]),
     {:ok, _} <- Battle.check_arena!(arena, "waiting") do
      arena = Combat.start(arena)
      json(conn, %{data: %{arena: arena}})
    end
  end

  def actions(conn, params) do
    args = Utils.atomify_map(params)
    with %Battle.Arena{} = arena <- Battle.get_arena!(args.arena_id),
      {:ok, _} <- Battle.check_arena!(arena, "fighting"),
      %Cards.MoveSet{} = action <- Cards.get_move_set!(args.action_id) do
      current_user = Plug.current_resource(conn)

      case Combat.actions(arena.id, current_user.id, action) do
        {:ok, new_buffer} -> json(conn, %{data: %{buffer: new_buffer}})
        _ -> {:error, :cant_insert}
      end
    end
  end

  def sync(conn, params) do
    with %Battle.Arena{} = arena <- Battle.get_arena!(params["id"]) do
      info = Combat.sync(arena.id)

      json(conn, %{data: %{arena: arena, info: info}})
    end
  end

  def forfeit(conn, params) do
    with %Battle.Arena{} = arena <- Battle.get_arena!(params["arena_id"]),
      {:ok, _} <- Battle.check_arena!(arena, "fighting"),
      current_user <- Utils.get_current_user(conn),
      {:ok, player} <- Battle.check_player!(arena.id, current_user.id) do
        winner =
          case player do
            :p1 -> arena.p2_id |> Luta.Auth.get_user!
            :p2 -> arena.p1_id |> Luta.Auth.get_user!
          end

        {:ok, neo_arena} = Battle.update_arena(arena, %{
          status: "closed",
          winner: winner.nick ,
          loser: current_user.nick
        })
        Luta.ETS.delete_table(arena.id)

        json(conn, %{data: %{arena: neo_arena}})
    end
  end
end
