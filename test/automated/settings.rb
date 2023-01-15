require_relative 'automated_init'

context "Settings" do
  settings = MessageStore::Settings.build

  context "Names" do
    settings_hash = settings.get.to_h

    names = MessageStore::Settings.names

    names.each do |name|
      test "#{name}" do
        assert(settings_hash.has_key? name.to_s)
      end
    end
  end
end
