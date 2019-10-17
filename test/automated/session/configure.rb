require_relative '../automated_init'

context "Session" do
  context "Configure" do
    context "Session is specified" do
      receiver = OpenStruct.new
      settings = Object.new
      session = Object.new

      Session.configure(receiver, session: session)

      test "Specified session is used" do
        assert(receiver.session == session)
      end
    end

    context "Settings is specified" do
      receiver = OpenStruct.new

      user = SecureRandom.hex

      settings_data = {
        user: user
      }

      settings = MessageStore::Postgres::Settings.build(settings_data)

      Session.configure(receiver, settings: settings)

      test "Session is built from settings" do
        assert(receiver.session.user == settings.get('user'))
      end
    end

    context "Specifying both the session and settings" do
      receiver = OpenStruct.new
      settings = Object.new
      session = Object.new

      test "Is an error" do
        assert_raises(Session::Error) do
          Session.configure(receiver, settings: settings, session: session)
        end
      end
    end
  end
end
