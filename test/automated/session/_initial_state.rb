require_relative '../automated_init'

context "Session" do
  test "Initial State" do
    session = Session.build
    connected = session.connected?

    test "Not connected" do
      refute(connected)
    end
  end
end
