require_relative '../automated_init'

context "Session" do
  test "On First Use" do
    session = Session.build

    refute(session.connected?)

    test "Connects" do
      refute_raises do
        session.execute(';')
      end
    end
  end
end
