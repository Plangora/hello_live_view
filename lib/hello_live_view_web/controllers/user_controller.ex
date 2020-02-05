defmodule HelloLiveViewWeb.UserController do
  use HelloLiveViewWeb, :controller

  def index(%{assigns: %{locale: locale}} = conn, _params) do
    live_render(conn, HelloLiveViewWeb.UserIndex, session: %{"locale" => locale})
  end
end
