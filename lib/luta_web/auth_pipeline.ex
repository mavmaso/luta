defmodule Luta.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :Luta,
  module: Luta.Guardian,
  error_handler: Luta.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
