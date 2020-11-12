defmodule LutaWeb.CombatController do
  # import Ecto.Query, warn: false

  use LutaWeb, :controller

  alias Luta.Battle
  alias Utils
  # alias Combat

  action_fallback LutaWeb.FallbackController

  def start(conn, params) do
    IO.inspect params
    json(conn, %{data: "WIP"})
  end
end
