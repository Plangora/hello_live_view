defmodule HelloLiveViewWeb.UserNew do
  use HelloLiveViewWeb, :live_view
  alias HelloLiveView.{Accounts, Accounts.User}

  def render(assigns), do: HelloLiveViewWeb.UserView.render("form.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :changeset, Accounts.change_new_user(%User{}))}
  end

  def handle_event("validate-user", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_new_user(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("submit-user", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:info, "User was successfully created!")
          |> redirect(to: Routes.user_path(socket, :index))

        {:stop, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
