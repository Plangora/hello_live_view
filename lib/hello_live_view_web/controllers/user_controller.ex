defmodule HelloLiveViewWeb.UserController do
  use HelloLiveViewWeb, :controller

  def show(conn, %{"id" => user_id}),
    do: live_render(conn, HelloLiveViewWeb.UserShow, session: %{"user_id" => user_id})

  def edit(conn, %{"id" => user_id}),
    do: live_render(conn, HelloLiveViewWeb.UserEdit, session: %{"user_id" => user_id})

  def index(%{assigns: %{locale: locale}} = conn, _params) do
    live_render(conn, HelloLiveViewWeb.UserIndex, session: %{"locale" => locale})
  end
end
