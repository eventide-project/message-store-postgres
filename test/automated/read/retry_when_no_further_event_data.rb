require_relative '../automated_init'

context "Read" do
  cycle = Cycle.build(delay_milliseconds: 10, timeout_milliseconds: 100)
  sink = Cycle.register_telemetry_sink(cycle)

  Read.('some_stream', batch_size: 1, cycle: cycle) { |event_data| }

  test "Timed out" do
    assert(sink.recorded_timed_out?)
  end
end
