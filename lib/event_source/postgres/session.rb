module EventStream
  module Postgres
    class Session
      def self.settings
        Settings.names
      end

      settings.each do |s|
        setting s
      end

      attr_accessor :connection

      dependency :logger, Telemetry::Logger

      def self.build(connection: nil, settings: nil)
        new.tap do |instance|
          Telemetry::Logger.configure instance

          settings ||= Settings.instance

          settings.set(instance)

          connect(instance, connection)
        end
      end

      def self.configure(receiver, session: nil, attr_name: nil)
        attr_name ||= :session

        instance = session || build
        receiver.public_send "#{attr_name}=", instance
        instance
      end

      def self.connect(instance, connection=nil)
        logger.trace "Connecting to database"

        if connection.nil?
          logger.debug "No connection. A new one will be built."
          connection = build_connection(instance)
        else
          logger.debug "Reusing existing connection"
        end

        instance.connection = connection

        logger.debug "Connected to database"

        connection
      end

      def self.build_connection(instance)
        settings = instance.settings
        logger.trace "Building new connection to database (Settings: #{LogText.settings(settings).inspect})"

        connection = PG::Connection.open(settings)
        connection.type_map_for_results = PG::BasicTypeMapForResults.new(connection)

        logger.trace "Built new connection to database (Settings: #{LogText.settings(settings).inspect})"

        connection
      end

      def connect
        self.class.connect(self)
      end

      def connected?
        !connection.nil? && connection.status == PG::CONNECTION_OK
      end
      alias :open? :connected?

      def close
        connection.close
        connection = nil
      end

      def reset
        connection.reset
      end

      def settings
        settings = {}
        self.class.settings.each do |s|
          val = public_send(s)
          settings[s] = val unless val.nil?
        end
        settings
      end

      def self.logger
        @logger ||= Telemetry::Logger.get self
      end

      module LogText
        def self.settings(settings)
          s = settings.dup

          if s.has_key?(:password)
            s[:password] = '(hidden)'
          end

          s
        end
      end
    end
  end
end
