require_relative "../automated_init"

context "Session" do
  context "Close" do
    context "Session is Open" do
      session = Session.build
      session.open

      assert(session.open?)

      session.close

      test "No longer connected" do
        refute(session.connected?)
      end

      context "Connection Attribute" do
        connection = session.connection

        test "Not set" do
          assert(connection.nil?)
        end
      end
    end

    context "Session is Closed" do
      session = Session.build

      refute(session.open?)

      session.close

      test "Not connected" do
        refute(session.connected?)
      end

      context "Connection Attribute" do
        connection = session.connection

        test "Not set" do
          assert(connection.nil?)
        end
      end
    end
  end
end
