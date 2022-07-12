require_relative '../automated_init'

context "Session" do
  context "Connection Executed Time" do
    context "Before First Execution" do
      session = Session.build

      test "Executed time isn't set" do
        assert(session.executed_time.nil?)
      end
    end

    context "After Execution" do
      session = Session.build
      Dependency::Substitute.(:clock, session)

      time = Controls::Time::Raw.example
      session.clock.now = time

      session.execute(';')

      test "Executed time is set to the clock time" do
        assert(session.executed_time == time)
      end
    end
  end
end
