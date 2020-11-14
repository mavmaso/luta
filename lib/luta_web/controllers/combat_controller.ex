defmodule LutaWeb.CombatController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle
  alias Utils
  # alias Combat

  action_fallback LutaWeb.FallbackController

  def start(conn, params) do
    with %Battle.Arena{} = arena <- Battle.get_arena!(params["arena_id"]) do
      #TODO
      json(conn, %{data: %{arena: arena}})
    else
      _ -> {:error, :not_found}
    end
  end
end
