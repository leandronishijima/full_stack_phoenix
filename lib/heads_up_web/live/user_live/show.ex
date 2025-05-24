defmodule HeadsUpWeb.UserLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Users
    </.header>

    <.table id="users" rows={@streams.users}>
      <:col :let={{_id, user}} label="Name">{user.username}</:col>
      <:col :let={{_id, user}} label="Email">{user.email}</:col>
      <:col :let={{_id, user}} label="Admin">{user.is_admin}</:col>
      <:action :let={{_id, user}}>
        <.link phx-click={JS.push("promote", value: %{id: user.id})} data-confirm="Are you sure?">
          Promote to Admin
        </.link>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Users")
     |> stream(:users, Accounts.list_users())}
  end

  @impl true
  def handle_event("promote", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    case Accounts.promote_to_admin(user) do
      {:ok, user} ->
        socket =
          socket
          |> put_flash(:info, "User promoted to admin!")
          |> stream_insert(:users, user)

        {:noreply, socket}

      {:error, _} ->
        # should never get here!
        {:noreply, put_flash(socket, :info, "Error promoting to admin!")}
    end
  end
end
