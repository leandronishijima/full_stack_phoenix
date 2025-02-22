defmodule HeadsUpWeb.Api.IncidentController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Admin

  def index(conn, _params) do
    incidents = Admin.list_incidents()

    render(conn, %{incidents: incidents})
  end

  def show(conn, %{"id" => id}) do
    incident = Admin.get_incident!(id)

    render(conn, %{incident: incident})
  end
end
