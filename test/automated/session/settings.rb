require_relative '../automated_init'

context "Session" do
  context "Settings" do
    session = Session.build

    settings = MessageStore::Settings.build
    settings_hash = settings.get.to_h

    names = MessageStore::Settings.names

    names.each do |name|
      test "#{name}" do
        session_val = session.public_send(name)
        settings_val = settings_hash[name.to_s]

        assert(session_val == settings_val)
      end
    end
  end
end
