defmodule HelloLiveViewWeb.UserEdit do
  use HelloLiveViewWeb, :live_view
  alias HelloLiveView.{Accounts, Accounts.User}

  def render(assigns), do: HelloLiveViewWeb.UserView.render("form.html", assigns)

  def mount(%{path_params: %{"id" => user_id}}, socket) do
    user = Accounts.get_user!(user_id)
    {:ok, assign(socket, changeset: Accounts.change_user(user), user: user)}
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
          |> redirect(to: Routes.live_path(socket, HelloLiveViewWeb.UserShow, user))
        {:stop, socket}
      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end