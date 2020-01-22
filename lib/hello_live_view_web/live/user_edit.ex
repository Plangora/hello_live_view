defmodule HelloLiveViewWeb.UserEdit do
  use HelloLiveViewWeb, :live_view
  alias HelloLiveView.Accounts
  alias HelloLiveViewWeb.Presence
  @topic "user_edit:"
  @key "editor"

  def render(assigns), do: HelloLiveViewWeb.UserView.render("form.html", assigns)

  def mount(%{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)

    if connected?(socket) do
      HelloLiveViewWeb.Endpoint.subscribe(topic(user_id))
      Presence.track(self(), topic(user_id), @key, %{})
    end

    {:ok,
     assign(socket,
       changeset: Accounts.change_user(user),
       user: user,
       number_of_users: number_of_users(user_id)
     )}
  end

  def handle_event("validate-user", %{"user" => user_params}, %{assigns: %{user: user}} = socket) do
    changeset =
      user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("submit-user", %{"user" => user_params}, %{assigns: %{user: user}} = socket) do
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        socket =
          socket
          |> put_flash(:info, "User was successfully updated!")
          |> redirect(to: Routes.user_path(socket, :show, user))

        {:stop, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_info(%{event: "presence_diff"}, %{assigns: %{user: %{id: user_id}}} = socket) do
    {:noreply, assign(socket, number_of_users: number_of_users(user_id))}
  end

  defp topic(user_id), do: @topic <> "#{user_id}"

  defp number_of_users(user_id) do
    case Presence.get_by_key(topic(user_id), @key) do
      [] -> 1
      %{metas: users} -> length(users)
    end
  end
end
