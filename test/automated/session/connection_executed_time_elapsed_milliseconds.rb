require_relative '../automated_init'

context "Session" do
  context "Connection Executed Time Elapsed Milliseconds" do
    context "Before First Execution" do
      session = Session.new

      test "Is nil" do
        assert(session.executed_time_elapsed_milliseconds.nil?)
      end
    end

    context "After Execution" do
      session = Session.new

      start_time = Controls::Time::Raw.example
      end_time = start_time + 1

      session.executed_time = start_time
      session.clock.now = end_time

      elapsed_milliseconds = (end_time - start_time) * 1000

      test "Is difference between current time and executed time" do
        assert(session.executed_time_elapsed_milliseconds == elapsed_milliseconds)
      end
    end
  end
end
