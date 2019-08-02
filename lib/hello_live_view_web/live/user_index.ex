defmodule HelloLiveViewWeb.UserIndex do
  use HelloLiveViewWeb, :live_view
  alias HelloLiveView.Accounts
  alias Accounts.User

  def render(assigns), do: HelloLiveViewWeb.UserView.render("index.html", assigns)

  def mount(%{locale: locale}, socket) do
    if connected?(socket) do 
      Accounts.subscribe()
      Gettext.put_locale(locale)
    end
    {:ok, assign(socket, users: Accounts.list_users(), changeset: Accounts.change_new_user(%User{}), open_modal: false)}
  end

  def handle_event("delete-user", user_id, socket) do
    user_id
    |> Accounts.get_user!()
    |> Accounts.delete_user()

    {:noreply, socket}
  end

  def handle_event("show-modal", _, socket), do: {:noreply, assign(socket, :open_modal, true)}

  def handle_event("close-modal", _, socket), do: {:noreply, assign(socket, :open_modal, false)}

  def handle_event("validate-user", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_new_user(user_params)
      |> Map.put(:action, :insert)
    {:noreply, assign(socket, changeset: changeset, user_params: user_params)}
  end

  def handle_event("submit-user", _, %{assigns: %{user_params: user_params}} = socket) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        {:noreply, assign(socket, open_modal: false, changeset: Accounts.change_new_user(%User{}))}
      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_info({Accounts, [:user, _], _}, socket),
    do: {:noreply, assign(socket, :users, Accounts.list_users())}
end
