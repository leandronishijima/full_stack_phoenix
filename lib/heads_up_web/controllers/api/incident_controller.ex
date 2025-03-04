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

  def create(conn, %{"incident" => incident_params}) do
    case Admin.create_incident(incident_params) do
      {:ok, incident} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/incidents/#{incident}")
        |> render(%{incident: incident})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end
end
