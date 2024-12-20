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

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort_by(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(pending resolved canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end

  defp sort_by(query, "name") do
    order_by(query, :name)
  end

  defp sort_by(query, "priority_desc") do
    order_by(query, desc: :priority)
  end

  defp sort_by(query, "priority_asc") do
    order_by(query, asc: :priority)
  end

  defp sort_by(query, _) do
    order_by(query, :id)
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
