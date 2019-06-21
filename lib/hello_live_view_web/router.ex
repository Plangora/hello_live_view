defmodule HelloLiveViewWeb.Router do
  use HelloLiveViewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloLiveViewWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/users", UserIndex
    live "/users/new", UserNew
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloLiveViewWeb do
  #   pipe_through :api
  # end
end
