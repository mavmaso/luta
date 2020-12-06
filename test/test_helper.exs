{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
ExUnit.configure exclude: [:heavy]
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Luta.Repo, :manual)
