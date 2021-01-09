defmodule LutaWeb.ProfileController do

  use LutaWeb, :controller

  alias Luta.{Progress}

  action_fallback LutaWeb.FallbackController

  def index(conn, params) do
    profiles = Progress.list_profile_by_season(params["season"])

    json(conn, %{data: %{profiles: profiles}})
  end
end
