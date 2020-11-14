defmodule LutaWeb.CombatController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle
  alias Utils
  alias Luta.Combat

  action_fallback LutaWeb.FallbackController

  def start(conn, params) do
    with %Battle.Arena{} = arena <- Battle.get_arena!(params["arena_id"]),
     {:ok, _} <- Battle.check_arena(arena, "waiting") do
      arena = Combat.start(arena)
      json(conn, %{data: %{arena: arena}})
    else
      _ -> {:error, :not_found}
    end
  end
end
