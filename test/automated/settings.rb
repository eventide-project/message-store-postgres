require_relative 'automated_init'

context "Settings" do
  settings = Postgres::Settings.build

  context "Names" do
    settings_hash = settings.get.to_h

    names = Postgres::Settings.names

    names.each do |name|
      test "#{name}" do
        assert(settings_hash.has_key? name)
      end
    end
  end
end
