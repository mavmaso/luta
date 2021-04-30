defmodule LutaWeb.Router do
  use LutaWeb, :router

  alias Luta.Guardian

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  pipeline :jwt_auth do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", LutaWeb do
    pipe_through :api

    get "/arenas", ArenaController, :index
    get "/arenas/:id", ArenaController, :show

    post "/sign_up", UserController, :create
    post "/login", UserController, :login

    get "/sync/:id", CombatController, :sync
  end

  scope "/api/v1", LutaWeb do
    pipe_through [:api, :jwt_auth]

    get "/my_user", UserController, :show

    resources "/arena", ArenaController, only: [:create, :delete]

    put "/join_arena", ArenaController, :join_arena
    put "/select_char", ArenaController, :select_char

    post "/start", CombatController, :start
    post "/actions", CombatController, :actions
    post "/forfeit", CombatController, :forfeit
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through [:fetch_session, :protect_from_forgery]
  #     live_dashboard "/dashboard", metrics: LutaWeb.Telemetry
  #   end
  # end
end
