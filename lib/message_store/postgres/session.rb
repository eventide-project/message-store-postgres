module MessageStore
  module Postgres
    class Session
      Error = Class.new(RuntimeError)

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

      def self.configure(receiver, session: nil, settings: nil, attr_name: nil)
        attr_name ||= :session

        if session != nil && settings != nil
          raise Error, "Session configured with both settings and session arguments. Use one or the other, but not both."
        end

        instance = session || build(settings: settings)
        receiver.public_send "#{attr_name}=", instance
        instance
      end

      def open
        logger.trace { "Connecting to database" }

        if connected?
          logger.debug { "Already connected. A new connection will not be built." }
          return connection
        end

        logger.debug { "Not connected. A new connection will be built." }
        connection = self.class.build_connection(self)
        self.connection = connection

        logger.debug { "Connected to database" }

        connection
      end
      alias :connect :open

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

      def execute(sql_command, params=nil)
        logger.trace { "Executing SQL command" }
        logger.trace(tag: :sql) { sql_command }
        logger.trace(tag: :data) { params.pretty_inspect }

        unless connected?
          connect
        end

        if params.nil?
          connection.exec(sql_command).tap do
            logger.debug { "Executed SQL command (no params)" }
          end
        else
          connection.exec_params(sql_command, params).tap do
            logger.debug { "Executed SQL command with params" }
          end
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
            s[:password] = '*' * 8
          end

          s
        end
      end
    end
  end
end
