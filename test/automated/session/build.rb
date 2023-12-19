require_relative '../automated_init'

context "Session" do
  context "Build" do
    context "Settings is specified" do
      control_setting = SecureRandom.hex

      settings = MessageStore::Postgres::Settings.build({
        user: control_setting
      })

      session = Session.build(settings: settings)

      setting = session.user

      test "Specified settings is used" do
        assert(setting == control_setting)
      end
    end

    context "Settings is not specified" do
      session = Session.build

      setting = session.user

      settings = MessageStore::Postgres::Settings.build
      control_setting = settings.get(:user)

      test "Settings is built" do
        assert(setting == control_setting)
      end
    end
  end
end
