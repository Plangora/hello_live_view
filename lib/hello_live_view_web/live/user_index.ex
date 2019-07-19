defmodule HelloLiveViewWeb.UserIndex do
  use HelloLiveViewWeb, :live_view
  alias HelloLiveView.Accounts

  def render(assigns), do: HelloLiveViewWeb.UserView.render("index.html", assigns)

  def mount(_session, socket) do
    if connected?(socket), do: Accounts.subscribe()
    {:ok, assign(socket, :users, Accounts.list_users())}
  end

  def handle_event("delete-user", user_id, socket) do
    user_id
    |> Accounts.get_user!()
    |> Accounts.delete_user()

    {:noreply, socket}
  end

  def handle_info({Accounts, [:user, _], _}, socket),
    do: {:noreply, assign(socket, :users, Accounts.list_users())}
end
