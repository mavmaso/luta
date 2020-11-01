defmodule LutaWeb.BattleController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle
  alias Utils

  # action_fallback LutaWeb.FallbackController

  def battle(conn, %{"arena_id" => _, "player" => _, "action" => _} = params) do
    result = Battle.battle_turn(Utils.atomify_map(params))
    json(conn, %{data: result})
  end
end
