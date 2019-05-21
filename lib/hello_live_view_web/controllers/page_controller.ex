defmodule HelloLiveViewWeb.PageController do
  use HelloLiveViewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
