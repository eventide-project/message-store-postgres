module EventSource
  module Postgres
    class Read
      class Error < RuntimeError; end

      include Log::Dependency

      initializer :stream

      dependency :iterator, Iterator

      def self.build(stream_name, position: nil, batch_size: nil, precedence: nil, partition: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil)
        stream = Stream.new(stream_name)

        if cycle.nil?
          cycle = Cycle.build(delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds)
        end

        cycle ||= Cycle.build(delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds)

        new(stream).tap do |instance|
          get = instance.build_get(stream, batch_size: batch_size, precedence: precedence, partition: partition, session: session)
          Iterator.configure instance, get, position: position, cycle: cycle
        end
      end

      ## TODO will need to be abstract
      def build_get(stream, batch_size: nil, precedence: nil, partition: nil, session: nil)
        Get.build(stream, batch_size: batch_size, precedence: precedence, partition: partition, session: session)
      end

      def self.call(stream_name, position: nil, batch_size: nil, precedence: nil, partition: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil, &action)
        instance = build(stream_name, position: position, batch_size: batch_size, precedence: precedence, partition: partition, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle, session: session)
        instance.(&action)
      end

      def self.configure(receiver, stream_name, attr_name: nil, position: nil, batch_size: nil, precedence: nil, partition: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil)
        attr_name ||= :reader
        instance = build(stream_name, position: position, batch_size: batch_size, precedence: precedence, partition: partition, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle, session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def call(&action)
        if action.nil?
          error_message = "Reader must be actuated with a block"
          logger.error error_message
          raise Error, error_message
        end

        enumerate_event_data(&action)

        return AsyncInvocation::Incorrect
      end

      def enumerate_event_data(&action)
        logger.trace { "Reading (Stream Name: #{stream.name}, Category: #{stream.category?})" }

        event_data = nil

        loop do
          event_data = iterator.next

          break if event_data.nil?

          action.(event_data)
        end

        logger.debug { "Finished reading (Stream Name: #{stream.name}, Category: #{stream.category?})" }
      end
    end
  end
end
