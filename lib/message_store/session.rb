module MessageStore
  class Session
    Error = Class.new(RuntimeError)

    include Dependency
    include Settings::Setting

    include Log::Dependency

    dependency :clock, Clock::UTC

    def self.settings
      Settings.names
    end

    settings.each do |s|
      setting s
    end

    attr_accessor :connection
    attr_accessor :executed_time

    def self.build(settings: nil)
      instance = new

      settings ||= Settings.instance
      settings.set(instance)

      Clock::UTC.configure(instance)

      instance
    end

    def self.configure(receiver, session: nil, settings: nil, attr_name: nil)
      attr_name ||= :session

      if session != nil && settings != nil
        error_msg = "Session configured with both settings and session arguments. Use one or the other, but not both."
        logger.error(tag: :session) { error_msg }
        raise Error, error_msg
      end

      instance = session || build(settings: settings)
      receiver.public_send "#{attr_name}=", instance
      instance
    end

    def open
      logger.trace(tag: :session) { "Connecting to database" }

      if connected?
        logger.debug(tag: :session) { "Already connected. A new connection will not be built." }
        return connection
      end

      logger.debug(tag: :session) { "Not connected. A new connection will be built." }
      connection = self.class.build_connection(self)
      self.connection = connection

      logger.debug(tag: :session) { "Connected to database" }

      connection
    end
    alias :connect :open

    def self.build_connection(instance)
      settings = instance.settings
      logger.trace(tag: :session) { "Building new connection to database (Settings: #{LogText.settings(settings).inspect})" }

      connection = PG::Connection.open(settings)
      connection.type_map_for_results = PG::BasicTypeMapForResults.new(connection)

      logger.debug(tag: :session) { "Built new connection to database (Settings: #{LogText.settings(settings).inspect})" }

      connection
    end

    def connected?
      return false if connection.nil?

      status = PG::CONNECTION_OK
      begin
        status = connection.status
      rescue PG::ConnectionBad
        status = nil
      end

      status == PG::CONNECTION_OK
    end
    alias :open? :connected?

    def close
      if connection.nil?
        return
      end

      connection.close
      self.connection = nil
    end

    def reset
      connection.reset
    end

    def execute(sql_command, params=nil)
      logger.trace(tag: :session) { "Executing SQL command" }
      logger.trace(tag: :sql) { sql_command }
      logger.trace(tag: :data) { params.pretty_inspect }

      unless connected?
        connect
      end

      if params.nil?
        connection.exec(sql_command).tap do
          self.executed_time = clock.now
          logger.debug(tag: :session) { "Executed SQL command (no params)" }
        end
      else
        connection.exec_params(sql_command, params).tap do
          self.executed_time = clock.now
          logger.debug(tag: :session) { "Executed SQL command with params" }
        end
      end
    end

    def executed_time_elapsed_milliseconds
      return nil if executed_time.nil?

      (clock.now - executed_time) * 1000
    end

    def transaction(&blk)
      unless connected?
        connect
      end

      connection.transaction(&blk)
    end

    def escape(data)
      connection = connect

      escaped_data = connection.escape(data)

      escaped_data
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
