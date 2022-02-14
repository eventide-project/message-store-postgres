require_relative '../automated_init'

context "Session" do
  context "Connection Time" do
    session = Session.new





    refute(session.connected?)

    test "Connects" do
      refute_raises do
        session.execute('SELECT 1;')
      end
    end
  end
end
