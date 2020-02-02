module MessageStore
  module Postgres
    class Settings < ::Settings
      def self.instance
        @instance ||= build
      end

      def self.data_source
        Defaults.data_source
      end

      def self.names
        [
          :dbname,
          :host,
          :hostaddr,
          :port,
          :user,
          :password,
          :connect_timeout,
          :options,
          :sslmode,
          :krbsrvname,
          :gsslib,
          :service
        ]
      end

      class Defaults
        def self.data_source
          ENV['MESSAGE_STORE_SETTINGS_PATH'] || 'settings/message_store_postgres.json'
        end
      end
    end
  end
end
