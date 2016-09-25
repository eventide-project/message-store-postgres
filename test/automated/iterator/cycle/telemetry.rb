require_relative '../../automated_init'

context "Iterator" do
  context "Cycle" do
    context "Telemetry" do
      context "Got Result" do
        cycle = Iterator::Cycle.build
        sink = Iterator::Cycle.register_telemetry_sink(cycle)

        cycle.() do
          'some result'
        end

        test "Recorded cycle" do
          iteration = 0
          assert(sink.recorded_cycle? { |r| r.data == iteration })
        end

        test "Recorded invoked action" do
          assert(sink.recorded_invoked_action?)
        end

        test "Recorded got result" do
          assert(sink.recorded_got_result?)
        end

        test "Didn't record delayed" do
          refute(sink.recorded_delayed?)
        end

        test "Didn't record timed out" do
          refute(sink.recorded_timed_out?)
        end
      end

      context "Got No Result" do
        cycle = Iterator::Cycle.build(delay_milliseconds: 50, timeout_milliseconds: 100)
        sink = Iterator::Cycle.register_telemetry_sink(cycle)
        cycle.() do
          nil
        end

        test "Recorded cycle" do
          assert(sink.recorded_cycle?)
        end

        test "Recorded invoked action" do
          assert(sink.recorded_invoked_action?)
        end

        test "Recorded delayed" do
          assert(sink.recorded_delayed?)
        end

        test "Recorded timed out" do
          assert(sink.recorded_timed_out?)
        end

        test "Didn't record got result" do
          refute(sink.recorded_got_result?)
        end
      end
    end
  end
end
