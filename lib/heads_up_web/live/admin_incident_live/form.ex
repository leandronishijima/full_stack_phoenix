defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(%{}, as: "incident"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= @page_title %>
    </.header>
    <.simple_form for={@form} id="incident-form">
      <.input field={@form["name"]} label="Name" />
      <.input field={@form["priority"]} type="number" label="Priority" />
      <.input
        field={@form["status"]}
        type="select"
        label="Status"
        prompt="Choose a status"
        options={Ecto.Enum.values(Incident, :status)}
      />
      <.input field={@form["description"]} type="textarea" label="Description" />
      <.input field={@form["image_path"]} label="Image Path" />

      <:actions>
        <.button>Save</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/incidents"}>
      Back
    </.back>
    """
  end
end
