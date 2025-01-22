defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: "fade-in",
          out: "fade-out"
        )
      }>
        Toggle Joke
      </.button>

      <div id="joke" class="joke hidden" phx-click={JS.toggle_class("blur")}>
        Why shouldn't you trust trees?
      </div>
      <.header>
        {@page_title}
        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">
            New Incident
          </.link>
        </:actions>
      </.header>
      <.table id="incidents" rows={@streams.incidents}>
        <:col :let={{_dom_id, incident}} label="Name">
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.name}
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Status">
          <.badge status={incident.status} />
        </:col>
        <:col :let={{_dom_id, incident}} label="Priority">
          {incident.priority}
        </:col>
        <:col :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident.id}/edit"}>
            Edit
          </.link>
        </:col>
        <:col :let={{dom_id, incident}}>
          <.link phx-click={delete_and_hide(dom_id, incident)} data-confirm="Are you sure?">
            <.icon name="hero-trash" class="h-4 w-4" />
          </.link>
        </:col>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)
    {:ok, _} = Admin.delete_incident(incident)

    {:noreply, stream_delete(socket, :incidents, incident)}
  end

  def delete_and_hide(dom_id, incident) do
    "delete"
    |> JS.push(value: %{id: incident.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
