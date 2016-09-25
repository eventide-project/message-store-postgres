module EventStream
  module Postgres
    class Read
      class Error < RuntimeError; end

      initializer :stream_name, :category, :stream_position, :batch_size, :precedence

      dependency :session, Session
      dependency :iterator, Iterator
      dependency :logger, Telemetry::Logger

      def self.build(stream_name: nil, category: nil, stream_position: nil, batch_size: nil, precedence: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil)
        new(stream_name, category, stream_position, batch_size, precedence).tap do |instance|
          Iterator.configure instance, stream_name: stream_name, category: category, stream_position: stream_position, batch_size: batch_size, precedence: precedence, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle, session: session
          Telemetry::Logger.configure instance
        end
      end

      def self.call(stream_name: nil, category: nil, stream_position: nil, batch_size: nil, precedence: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil, &action)
        instance = build(stream_name: stream_name, category: category, stream_position: stream_position, batch_size: batch_size, precedence: precedence, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle, session: session)
        instance.(&action)
      end

      def self.configure(receiver, attr_name: nil, stream_name: nil, category: nil, stream_position: nil, batch_size: nil, precedence: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil)
        attr_name ||= :reader
        instance = build(stream_name: stream_name, category: category, stream_position: stream_position, batch_size: batch_size, precedence: precedence, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle, session: session)
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
        logger.opt_trace "Reading event data (Stream Name: #{stream_name.inspect}, Category: #{category.inspect}, Stream Position: #{stream_position.inspect}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect})"

        event_data = nil

        loop do
          event_data = iterator.next

          break if event_data.nil?

          action.(event_data)
        end

        logger.opt_debug "Finished reading event data (Stream Name: #{stream_name.inspect}, Category: #{category.inspect}, Stream Position: #{stream_position.inspect}, Batch Size: #{batch_size.inspect}, Precedence: #{precedence.inspect})"
      end
    end
  end
end
