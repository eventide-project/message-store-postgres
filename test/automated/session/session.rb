require_relative '../automated_init'

context "Session" do
  test "Connected" do
    connected_session = Session.build
    connected = connected_session.connected?

    assert(connected)
  end
end
