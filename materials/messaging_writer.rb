module EventStore
  module Messaging
    class Writer
      class Error < StandardError; end

      dependency :writer, EventStore::Client::HTTP::EventWriter
      dependency :logger, ::Telemetry::Logger
      dependency :telemetry, ::Telemetry

      def self.build(session: nil)
        new.tap do |instance|
          EventStore::Client::HTTP::EventWriter.configure instance, session: session
          ::Telemetry::Logger.configure instance
          ::Telemetry.configure instance
        end
      end

      def self.configure(receiver, session: nil)
        instance = build(session: session)
        receiver.writer = instance
        instance
      end

      def write(message, stream_name, expected_version: nil, reply_stream_name: nil)
        unless message.is_a? Array
          logger.trace "Writing (Message Type: #{message.message_type}, Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        else
          logger.trace "Writing batch (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        end

        if reply_stream_name
          message.metadata.reply_stream_name = reply_stream_name
        end

        event_data = event_data_batch(message)

        writer.write(event_data, stream_name, expected_version: expected_version)

        unless message.is_a? Array
          logger.debug "Wrote (Message Type: #{message.message_type}, Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        else
          logger.debug "Wrote batch (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
        end

        Array(message).each do |written_message|
          telemetry.record :written, Telemetry::Data.new(written_message, stream_name, expected_version, reply_stream_name)
        end

        event_data
      end

      def write_initial(message, stream_name)
        write(message, stream_name, expected_version: :no_stream)
      end

      def event_data_batch(messages)
        messages = [messages] unless messages.is_a? Array

        batch = messages.map do |message|
          EventStore::Messaging::Message::Export::EventData.(message)
        end

        batch
      end

      def reply(message)
        metadata = message.metadata
        reply_stream_name = metadata.reply_stream_name

        logger.trace "Replying (Message Type: #{message.message_type}, Stream Name: #{reply_stream_name})"

        unless reply_stream_name
          error_msg = "Message has no reply stream name. Cannot reply. (Message Type: #{message.message_type})"
          logger.error error_msg
          raise Error, error_msg
        end

        metadata.clear_reply_stream_name

        write message, reply_stream_name

        logger.debug "Replied (Message Type: #{message.message_type}, Stream Name: #{reply_stream_name})"

        telemetry.record :replied, Telemetry::Data.new(message, reply_stream_name)

        message
      end

      def self.logger
        @logger ||= ::Telemetry::Logger.get self
      end

      def self.register_telemetry_sink(writer)
        sink = Telemetry.sink
        writer.telemetry.register sink
        sink
      end

      module Telemetry
        class Sink
          include ::Telemetry::Sink

          record :written
          record :replied
        end

        Data = Struct.new :message, :stream_name, :expected_version, :reply_stream_name

        def self.sink
          Sink.new
        end
      end

      module Substitute
        def self.build
          Substitute::Writer.build.tap do |substitute_writer|
            sink = Messaging::Writer.register_telemetry_sink(substitute_writer)
            substitute_writer.sink = sink
          end
        end

        class Writer < EventStore::Messaging::Writer
          attr_accessor :sink

          def self.build(session: nil)
            logger.trace "Building substitute"
            new.tap do |instance|
              ::Telemetry::Logger.configure instance
              ::Telemetry.configure instance
              logger.debug "Built substitute"
            end
          end

          def writes(&blk)
            if blk.nil?
              return sink.written_records
            end

            sink.written_records.select do |record|
              blk.call(record.data.message, record.data.stream_name, record.data.expected_version, record.data.reply_stream_name)
            end
          end

          def written?(&blk)
            if blk.nil?
              return sink.recorded_written?
            end

            sink.recorded_written? do |record|
              blk.call(record.data.message, record.data.stream_name, record.data.expected_version, record.data.reply_stream_name)
            end
          end

          def replies(&blk)
            if blk.nil?
              return sink.replied_records
            end

            sink.replied_records.select do |record|
              blk.call(record.data.message, record.data.stream_name)
            end
          end

          def replied?(&blk)
            if blk.nil?
              return sink.recorded_replied?
            end

            sink.recorded_replied? do |record|
              blk.call(record.data.message, record.data.stream_name)
            end
          end
        end
      end
    end
  end
end
