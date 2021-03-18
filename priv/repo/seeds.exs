alias Luta.{Repo, Auth, Battle}

Repo.insert!(%Auth.User{
  login: "test1",
  password: "$2b$12$lynEj0nByrRfq.GOkwt9luJf17iEbTjuUeYF7ALC2x.a/dDvc0Ioi",
  nick: "Primeiro"
  })
Repo.insert!(%Auth.User{
  login: "test2",
  password: "$2b$12$lynEj0nByrRfq.GOkwt9luJf17iEbTjuUeYF7ALC2x.a/dDvc0Ioi",
  nick: "Segundo"
  })

Repo.insert!(%Battle.Arena{name: "test", status: "closed"})
Repo.insert!(%Battle.Arena{name: "outra", status: "closed"})
