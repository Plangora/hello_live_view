defmodule HelloLiveViewWeb.Limit do
  use HelloLiveViewWeb, :live_view

  def render(assigns), do: HelloLiveViewWeb.PageView.render("limit.html", assigns)

  def mount(_session, socket) do
    {:ok, assign(socket, clicked: "")}
  end

  def handle_event("click-event", _, socket) do
    {:noreply, assign(socket, :clicked, DateTime.utc_now())}
  end
end
