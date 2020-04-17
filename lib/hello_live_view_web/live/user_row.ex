defmodule HelloLiveViewWeb.UserRow do
  use HelloLiveViewWeb, :live_component
  alias HelloLiveView.Accounts

  def render(assigns) do
    ~L"""
    <%= if @user do %>
      <li class="list-group-item" id="user-<%= @myself %>">
        <%= link(@user.username, to: Routes.live_path(@socket, HelloLiveViewWeb.UserShow, @user)) %>
        <%= link("Edit", to: Routes.live_path(@socket, HelloLiveViewWeb.UserEdit, @user), class: "btn btn-warning") %>
        <button type="button" class="btn btn-danger" phx-click="delete-user" phx-value-id="<%= @user.id %>">Delete</button>
      </li>
    <% end %>
    """
  end

  def handle_event("delete", _, socket) do
    IO.inspect(socket)
#    Accounts.delete_user(user)
    {:noreply, assign(socket, :user, nil)}
  end

  # [%{id: user_id}]
  def preload(list_of_assigns) do
    list_of_ids = Enum.map(list_of_assigns, & &1.id)

    users =
      list_of_ids
      |> Accounts.list_users_by_ids()
      |> Map.new()

    # [%{id: user_id, user: user}]
    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :user, users[assigns.id])
    end)
  end
end
