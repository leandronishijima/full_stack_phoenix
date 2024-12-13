defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo

  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def filter_incidents do
    query =
      from i in Incident,
        where: [status: :resolved],
        where: ilike(i.name, "%in%"),
        order_by: [desc: :name]

    Repo.all(query)
  end

  def urgent_incidents(incident) do
    query =
      from i in Incident,
        where: i.id != ^incident.id,
        order_by: [asc: :priority],
        limit: 3

    Repo.all(query)
  end
end
