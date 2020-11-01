defmodule Luta.Repo do
  use Ecto.Repo,
    otp_app: :luta,
    adapter: Ecto.Adapters.Postgres
end
