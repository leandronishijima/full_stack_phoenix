defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo

  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Incident
    |> Repo.get!(id)
    |> Repo.preload(:category)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> with_category(filter["category"])
    |> sort_by(filter["sort_by"])
    |> preload(:category)
    |> Repo.all()
  end

  defp with_category(query, slug) when slug in [nil, ""], do: query

  defp with_category(query, slug) do
    from i in query,
      join: c in assoc(i, :category),
      where: c.slug == ^slug
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

  defp sort_by(query, "category") do
    from i in query,
      join: c in assoc(i, :category),
      order_by: c.name
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

    Process.sleep(2000)

    Repo.all(query)
  end
end
