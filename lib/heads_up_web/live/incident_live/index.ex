defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incident
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, incidents: Incidents.list_incidents())}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, Incident, required: true

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path} />
      <h2><%= @incident.name %></h2>
      <div class="details">
        <.badge status={@incident.status} />
        <div class="priority">
          <%= @incident.priority %>
        </div>
      </div>
    </div>
    """
  end

  attr :status, :atom, values: [:pending, :resolved, :canceled], required: true

  def badge(assigns) do
    ~H"""
    <div class="rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border text-lime-600 border-lime-600">
      <%= @status %>
    </div>
    """
  end
end
