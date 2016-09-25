module EventStream
  module Postgres
    class Iterator
      class Error < RuntimeError; end

      attr_accessor :batch
      attr_writer :batch_position
      attr_writer :stream_offset

      def batch_position
        @batch_position ||= 0
      end

      def stream_offset
        @stream_offset ||= (stream_position || 0)
      end

      dependency :get, Get
      dependency :cycle, Cycle
      dependency :logger, Telemetry::Logger

      initializer :stream_name, :category, a(:stream_position, 0), :batch_size, :precedence

      def self.build(stream_name: nil, category: nil, stream_position: nil, batch_size: nil, precedence: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil)
        new(stream_name, category, stream_position, batch_size, precedence).tap do |instance|
          Get.configure instance, stream_name: stream_name, category: category, batch_size: batch_size, precedence: precedence, session: session
          Telemetry::Logger.configure instance
          Iterator::Cycle.configure instance, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle
        end
      end

      def self.configure(receiver, attr_name: nil, stream_name: nil, category: nil, stream_position: nil, batch_size: nil, precedence: nil, delay_milliseconds: nil, timeout_milliseconds: nil, cycle: nil, session: nil)
        attr_name ||= :iterator
        instance = build(stream_name: stream_name, category: category, stream_position: stream_position, batch_size: batch_size, precedence: precedence, delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, cycle: cycle, session: session)
        receiver.public_send "#{attr_name}=", instance
      end

      def next
        logger.opt_trace "Getting next event data (Batch Length: #{batch.nil? ? '<none>' : batch.length}, Batch Position: #{batch_position}, Stream Offset: #{stream_offset})"

        resupply(batch)

        event_data = batch[batch_position]

        logger.opt_debug "Finished getting next event data (Batch Length: #{batch.nil? ? '<none>' : batch.length}, Batch Position: #{batch_position}, Stream Offset: #{stream_offset})"
        logger.opt_data "Event Data: #{event_data.inspect}"

        advance_positions

        event_data
      end

      def resupply(batch)
        logger.opt_trace "Resupplying batch"

        if batch.nil?
          batch_log_text = "Batch: #{batch.inspect}"
        else
          batch_log_text = "Batch Length: #{batch.length}"
        end

        if batch.nil? || batch_position == batch.length
          logger.debug "Current batch is depleted (#{batch_log_text}, Batch Position: #{batch_position})"

          batch = get_batch
          reset(batch)
        else
          logger.debug "Current batch not depleted (#{batch_log_text}, Batch Position: #{batch_position})"
        end

        logger.opt_debug "Finished resupplying batch"
      end

      def reset(batch)
        logger.opt_trace "Resetting batch"

        self.batch = batch
        self.batch_position = 0

        logger.opt_debug "Reset batch"
        logger.opt_data ("Batch: #{batch.inspect}")
        logger.opt_data ("Batch Position: #{batch_position.inspect}")
      end

      def get_batch
        logger.opt_trace "Getting batch"

        batch = nil
        cycle.() do
          batch = get.(stream_position: stream_offset)
        end

        logger.opt_debug "Finished getting batch (Count: #{batch.length})"

        batch
      end

      def advance_positions
        logger.opt_trace "Advancing positions (Batch Position: #{batch_position}, Stream Offset: #{stream_offset})"
        self.batch_position += 1
        self.stream_offset += 1
        logger.opt_debug "Advanced positions (Batch Position: #{batch_position}, Stream Offset: #{stream_offset})"
      end
    end
  end
end
