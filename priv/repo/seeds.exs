alias Luta.Repo

## CHARS

Repo.insert!(%Luta.Char.Fighter{
  title: "Ninja Pop",
  atk: "5",
  def: "3",
  spd: "7",
  hps: "65",
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
  type: "A",
  description: "Bloqueio",
  power: 2,
  special: "nada",
  start_up: 3
})
