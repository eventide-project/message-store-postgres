module EventSource
  module Postgres
    class Session
      include Log::Dependency

      def self.settings
        Settings.names
      end

      settings.each do |s|
        setting s
      end

      attr_accessor :connection

      def self.build(settings: nil)
        new.tap do |instance|
          settings ||= Settings.instance
          settings.set(instance)
        end
      end

      def self.configure(receiver, session: nil, attr_name: nil)
        attr_name ||= :session

        instance = session || build
        receiver.public_send "#{attr_name}=", instance
        instance
      end

      def connect
        logger.trace "Connecting to database"

        if connected?
          logger.debug { "Already connected. A new connection will not be built." }
          return
        end

        logger.debug { "Not connected. A new connection will be built." }
        connection = self.class.build_connection(self)
        self.connection = connection

        logger.debug { "Connected to database" }

        connection
      end

      def self.build_connection(instance)
        settings = instance.settings
        logger.trace { "Building new connection to database (Settings: #{LogText.settings(settings).inspect})" }

        connection = PG::Connection.open(settings)
        connection.type_map_for_results = PG::BasicTypeMapForResults.new(connection)

        logger.trace { "Built new connection to database (Settings: #{LogText.settings(settings).inspect})" }

        connection
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

      def execute(statement, params=nil)
        unless connected?
          connect
        end

        if params.nil?
          connection.exec(statement)
        else
          connection.exec_params(statement, params)
        end
      end

      def transaction(&blk)
        unless connected?
          connect
        end

        connection.transaction(&blk)
      end

      def self.logger
        @logger ||= Log.get self
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
