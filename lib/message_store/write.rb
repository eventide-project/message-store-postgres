module MessageStore
  class Write
    include Dependency
    include Virtual
    include Log::Dependency

    dependency :identifier, Identifier::UUID::Random
    dependency :put

    def self.build(session: nil)
      instance = new
      Identifier::UUID::Random.configure(instance)
      instance.configure(session: session)
      instance
    end

    def self.configure(receiver, session: nil, attr_name: nil)
      attr_name ||= :write
      instance = build(session: session)
      receiver.public_send "#{attr_name}=", instance
    end

    def self.call(message_data, stream_name, expected_version: nil, session: nil)
      instance = build(session: session)
      instance.(message_data, stream_name, expected_version: expected_version)
    end

    def configure(session: nil)
      Put.configure(self, session: session)
    end

    def call(message_data, stream_name, expected_version: nil)
      batch = Array(message_data)

      logger.trace(tag: :write) do
        message_types = batch.map {|message_data| message_data.type }.uniq.join(', ')
        "Writing message data (Types: #{message_types}, Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect}, Number of Messages: #{batch.length})"
      end
      logger.trace(tags: [:data, :message_data]) { batch.pretty_inspect }

      set_ids(batch)

      position = write(batch, stream_name, expected_version: expected_version)

      logger.info(tag: :write) do
        message_types = batch.map {|message_data| message_data.type }.uniq.join(', ')
        "Wrote message data (Types: #{message_types}, Stream Name: #{stream_name}, Expected Version: #{expected_version.inspect}, Number of Messages: #{batch.length})"
      end
      logger.info(tags: [:data, :message_data]) { batch.pretty_inspect }

      position
    end

    def write(batch, stream_name, expected_version: nil)
      logger.trace(tag: :write) do
        message_types = batch.map {|message_data| message_data.type }.uniq.join(', ')
        "Writing batch (Stream Name: #{stream_name}, Types: #{message_types}, Number of Messages: #{batch.length}, Expected Version: #{expected_version.inspect})"
      end

      unless expected_version.nil?
        expected_version = ExpectedVersion.canonize(expected_version)
      end

      last_position = nil
      put.session.transaction do
        batch.each do |message_data|
          last_position = write_message_data(message_data, stream_name, expected_version: expected_version)

          unless expected_version.nil?
            expected_version += 1
          end
        end
      end

      logger.debug(tag: :write) do
        message_types = batch.map {|message_data| message_data.type }.uniq.join(', ')
        "Wrote batch (Stream Name: #{stream_name}, Types: #{message_types}, Number of Messages: #{batch.length}, Expected Version: #{expected_version.inspect})"
      end

      last_position
    end

    def write_message_data(message_data, stream_name, expected_version: nil)
      logger.trace(tag: :write) { "Writing message data (Stream Name: #{stream_name}, Type: #{message_data.type}, Expected Version: #{expected_version.inspect})" }
      logger.trace(tags: [:data, :message_data]) { message_data.pretty_inspect }

      put.(message_data, stream_name, expected_version: expected_version).tap do
        logger.debug(tag: :write) { "Wrote message data (Stream Name: #{stream_name}, Type: #{message_data.type}, Expected Version: #{expected_version.inspect})" }
        logger.debug(tags: [:data, :message_data]) { message_data.pretty_inspect }
      end
    end

    def set_ids(batch)
      batch.each do |message_data|
        if message_data.id.nil?
          message_data.id = identifier.get
        end
      end
    end
  end
end
