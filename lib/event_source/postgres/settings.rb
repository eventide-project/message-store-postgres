module MessageStore
  module Postgres
    class Settings < ::Settings
      def self.instance
        @instance ||= build
      end

      def self.data_source
        'settings/message_store_postgres.json'
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
    end
  end
end
