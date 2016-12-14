require_relative '../automated_init'

context "Session" do
  test "On First Use" do
    session = Session.build

    refute(session.connected?)

    test "Connects" do
      refute proc { session.execute('SELECT 1;') } do
        raises_error?
      end
    end
  end
end
