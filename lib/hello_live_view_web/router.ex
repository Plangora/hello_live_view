defmodule HelloLiveViewWeb.Router do
  use HelloLiveViewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
    plug HelloLiveViewWeb.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloLiveViewWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/users/new", UserNew
    resources "/users", UserController, only: [:index, :show, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloLiveViewWeb do
  #   pipe_through :api
  # end
end
