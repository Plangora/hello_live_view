defmodule HelloLiveView.Repo do
  use Ecto.Repo,
    otp_app: :hello_live_view,
    adapter: Ecto.Adapters.Postgres
end
