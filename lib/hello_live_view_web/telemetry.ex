defmodule HelloLiveViewWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg), do: Supervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def init(_arg) do
    children = []
    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      summary("phoenix.endpoint.stop.duration", unit: {:native, :millisecond}),
      summary("phoenix.endpoint.stop.duration",
        tags: [:method, :request_path],
        tag_values: &tag_method_and_request_path/1,
        unit: {:native, :millisecond}
      ),

      summary("hello_live_view.repo.query.total_time", unit: {:native, :millisecond}),
      summary("hello_live_view.repo.query.query_time", unit: {:native, :millisecond}),

      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io"),
    ]
  end

  defp tag_method_and_request_path(metadata),
    do: Map.take(metadata.conn, [:method, :request_path])
end
