module MessageStore
  class Read
    include Dependency
    include Initializer
    include Virtual
    include Log::Dependency

    Error = Class.new(RuntimeError)

    dependency :iterator, Iterator

    initializer :stream_name, :position, :batch_size

    def self.build(stream_name, position: nil, batch_size: nil, session: nil, condition: nil, **arguments)
      instance = new(stream_name, position, batch_size)

      Iterator.configure(instance, position)

      iterator = instance.iterator
      Get.configure(iterator, stream_name, batch_size: batch_size, condition: condition, session: session)

      instance
    end

    def self.call(stream_name, position: nil, batch_size: nil, session: nil, **arguments, &action)
      instance = build(stream_name, position: position, batch_size: batch_size, session: session, **arguments)
      instance.(&action)
    end

    def self.configure(receiver, stream_name, attr_name: nil, position: nil, batch_size: nil, session: nil, **arguments)
      attr_name ||= :read
      instance = build(stream_name, position: position, batch_size: batch_size, session: session, **arguments)
      receiver.public_send "#{attr_name}=", instance
    end

    def call(&action)
      logger.trace(tag: :read) { "Reading (Stream Name: #{stream_name})" }

      if action.nil?
        error_message = "Reader must be actuated with a block"
        logger.error(tag: :read) { error_message }
        raise Error, error_message
      end

      enumerate_message_data(&action)

      logger.info(tag: :read) { "Reading completed (Stream Name: #{stream_name})" }

      return AsyncInvocation::Incorrect
    end

    def enumerate_message_data(&action)
      logger.trace(tag: :read) { "Enumerating (Stream Name: #{stream_name})" }

      message_data = nil

      loop do
        message_data = iterator.next

        break if message_data.nil?
        logger.debug(tags: [:data, :message_data]) { message_data.pretty_inspect }

        action.(message_data)
      end

      logger.debug(tag: :read) { "Enumerated (Stream Name: #{stream_name})" }
    end

    module Defaults
      def self.batch_size
        Get::Defaults.batch_size
      end
    end
  end
end
