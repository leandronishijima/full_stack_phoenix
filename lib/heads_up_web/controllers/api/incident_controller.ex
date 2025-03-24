defmodule HeadsUpWeb.Api.IncidentController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Admin

  def index(conn, _params) do
    incidents = Admin.list_incidents()

    render(conn, :index, incidents: incidents)
  end

  def show(conn, %{"id" => id}) do
    incident = Admin.get_incident!(id)

    render(conn, :show, incident: incident)
  end

  def create(conn, %{"incident" => incident_params}) do
    case Admin.create_incident(incident_params) do
      {:ok, incident} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/incidents/#{incident}")
        |> render(:show, incident: incident)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        # |> put_view(json: HeadsUpWeb.Api.CategoryJSON)
        |> render(:error, changeset: changeset)
    end
  end
end
