alias Luta.{Repo, Auth, Battle}

Repo.insert!(%Auth.User{login: "test1", password: "123123", nick: "Primeiro"})
Repo.insert!(%Auth.User{login: "test2", password: "123123", nick: "Segundo"})

Repo.insert!(%Battle.Arena{name: "test", status: "closed"})
