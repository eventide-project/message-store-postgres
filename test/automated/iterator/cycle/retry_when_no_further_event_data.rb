require_relative '../../automated_init'

context "Iterator" do
  context "Cycle" do
    context "Retry when no further event data" do
      cycle = Iterator::Cycle.build(delay_milliseconds: 10, timeout_milliseconds: 100)
      sink = Iterator::Cycle.register_telemetry_sink(cycle)

      iterator = Iterator.build(stream_name: 'some_stream', cycle: cycle)

      iterator.next

      test "Didn't get result" do
        refute(sink.recorded_got_result?)
      end

      test "Delayed before retrying" do
        assert(sink.recorded_delayed?)
      end

      test "Timed out" do
        assert(sink.recorded_timed_out?)
      end
    end
  end
end
