import Ecto.Query

alias HeadsUp.Repo
alias HeadsUp.Incidents.Incident

# all the pending incidents, ordered by descending priority

query =
  from(Incident,
    where: [status: :pending],
    order_by: [desc: :priority]
  )

Repo.all(query) |> IO.inspect()

query =
  Incident
  |> where(status: :pending)
  |> order_by(desc: :priority)

Repo.all(query) |> IO.inspect()

# incidents with a priority greater than or equal to 2,
# ordered by ascending name

query =
  from(i in Incident,
    where: i.priority >= 2,
    order_by: :name
  )

Repo.all(query) |> IO.inspect()

query =
  Incident
  |> where([i], i.priority >= 2)
  |> order_by(:name)

Repo.all(query) |> IO.inspect()

# incidents that have "meow" anywhere in the description

query =
  from(i in Incident,
    where: ilike(i.description, "%meow%")
  )

Repo.all(query) |> IO.inspect()

query =
  Incident
  |> where([i], ilike(i.description, "%meow%"))

Repo.all(query) |> IO.inspect()

# the first and last incidentsn

Incident |> first(:id) |> Repo.one() |> IO.inspect()

Incident |> last(:id) |> Repo.one() |> IO.inspect()
