alias Luta.Repo

## USERS

Repo.insert!(%Luta.Auth.User{
  login: "sasuke",
  password: "$2b$12$iWNYYuxNcQhaUuJ82jLKu..jbrQQl8..it6K5AvdVovOwDmLX2OVu",
  nick: "sasukerk"
})

Repo.insert!(%Luta.Auth.User{
  login: "test1",
  password: "$2b$12$iWNYYuxNcQhaUuJ82jLKu..jbrQQl8..it6K5AvdVovOwDmLX2OVu",
  nick: "test1"
})

## CHARS

Repo.insert!(%Luta.Char.Fighter{
  title: "Ninja Pop",
  atk: "5",
  def: "3",
  spd: "7",
  hps: "65",
})

Repo.insert!(%Luta.Char.Fighter{
  title: "Sword Player",
  atk: "7",
  def: "3",
  spd: "6",
  hps: "90",
})


## CARDS

Repo.insert!(%Luta.Cards.MoveSet{
  type: "D",
  description: "Ataque de Katana",
  power: 5,
  special: "nada",
  start_up: 3
})

Repo.insert!(%Luta.Cards.MoveSet{
  type: "D",
  description: "Corte Duplo",
  power: 8,
  special: "nada",
  start_up: 5
})

Repo.insert!(%Luta.Cards.MoveSet{
  type: "A",
  description: "Bloqueio",
  power: 2,
  special: "nada",
  start_up: 3
})
