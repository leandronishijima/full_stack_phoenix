defmodule HeadsUpWeb.AdminIncidentLive.Form do
  alias HeadsUp.Admin
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Categories

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:categories_options, Categories.category_names_and_ids())
      |> apply_action(socket.assigns.live_action, params)

    {:ok, apply_action(socket, socket, params)}
  end

  def apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident)

    socket
    |> assign(:page_title, "New Incident")
    |> assign(:form, to_form(changeset))
    |> assign(:incident, incident)
  end

  def apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident)

    socket
    |> assign(:page_title, "New Incident")
    |> assign(:form, to_form(changeset))
    |> assign(:incident, incident)
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:name]} label="Name" />

      <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />

      <.input field={@form[:priority]} type="number" label="Priority" />

      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status"
        options={Ecto.Enum.values(Incident, :status)}
      />

      <.input
        field={@form[:category_id]}
        type="select"
        label="Category"
        prompt="Choose a category"
        options={@categories_options}
      />

      <.input field={@form[:image_path]} label="Image Path" />

      <:actions>
        <.button phx-disable-with="Saving...">Save Incident</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/incidents"}>Back</.back>
    """
  end

  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset = Admin.change_incident(%Incident{}, incident_params)

    socket = assign(socket, :form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("save", %{"incident" => incident}, socket) do
    save_incident(socket, socket.assigns.live_action, incident)
  end

  def save_incident(socket, :new, incident_params) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created successfully!")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def save_incident(socket, :edit, incident_params) do
    case Admin.update_incident(socket.assigns.incident, incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident updated successfully!")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end
end
