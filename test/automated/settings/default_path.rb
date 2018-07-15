require_relative '../automated_init'

context "Settings" do
  context "Default Path" do
    prior_default_settings_path = ENV['MESSAGE_STORE_SETTINGS_PATH']

    overridden_path = 'some_path'
    ENV['MESSAGE_STORE_SETTINGS_PATH'] = overridden_path

    settings_path = Postgres::Settings.data_source

    test "Overridden by MESSAGE_STORE_SETTINGS_PATH environment variable" do
      assert(settings_path == overridden_path)
    end

    ENV['MESSAGE_STORE_SETTINGS_PATH'] = prior_default_settings_path
  end
end
