alias Luta.{Repo, Auth, Battle}

Repo.insert!(%User{login: "test1", password: "123123", nick: "Primeiro"})
Repo.insert!(%User{login: "test2", password: "123123", nick: "Segundo"})

Repo.insert!(%Arena{name: "test", status: "closed"})
