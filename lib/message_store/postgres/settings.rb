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
          :host,
          :hostaddr,
          :port,
          :dbname,
          :user,
          :password,
          :passfile,
          :channel_binding,
          :connect_timeout,
          :client_encoding,
          :options,
          :application_name,
          :fallback_application_name,
          :keepalives,
          :keepalives_idle,
          :keepalives_interval,
          :keepalives_count,
          :tcp_user_timeout,
          :replication,
          :database,
          :gssencmode,
          :sslmode,
          :requiressl,
          :sslcompression,
          :sslcert,
          :sslkey,
          :sslpassword,
          :sslrootcert,
          :sslcrl,
          :sslcrldir,
          :sslsni,
          :requirepeer,
          :ssl_min_protocol_version,
          :ssl_max_protocol_version,
          :krbsrvname,
          :gsslib,
          :service,
          :target_session_attrs
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
