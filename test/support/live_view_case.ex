defmodule HelloLiveViewWeb.LiveViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import Phoenix.LiveViewTest
      alias HelloLiveViewWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint HelloLiveViewWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(HelloLiveView.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(HelloLiveView.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
