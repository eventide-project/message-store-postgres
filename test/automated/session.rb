require_relative 'automated_init'

context "Session" do
  test "Connected" do
    connected_session = Session.build
    connected = connected_session.connected?

    assert(connected)
  end

  context "Settings" do
    session = Session.build

    settings = Postgres::Settings.build
    settings_hash = settings.get.to_h

    names = Postgres::Settings.names

    names.each do |name|
      test "#{name}" do
        session_val = session.public_send name
        settings_val = settings_hash[name]

        assert(session_val == settings_val)
      end
    end
  end
end
