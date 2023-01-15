## Add tests - Aaron, Sun Jan 15 2023
module MessageStore
  class Read
    class Iterator
      include Dependency
      include Initializer
      include Virtual
      include Log::Dependency

      dependency :get, Get

      attr_accessor :batch

      def starting_position
        @starting_position ||= 0
      end
      attr_writer :starting_position

      def batch_index
        @batch_index ||= 0
      end
      attr_writer :batch_index

      def batch_size
        get.batch_size
      end

      def self.build(position=nil)
        instance = new
        instance.starting_position = position
        Log.get(self).debug { "Built Iterator (Starting Position: #{position.inspect})" }
        instance
      end

      def self.configure(receiver, position=nil, attr_name: nil)
        attr_name ||= :iterator
        instance = build(position)
        receiver.public_send "#{attr_name}=", instance
      end

      def next
        logger.trace { "Getting next message data (Batch Length: #{(batch &.length).inspect}, Batch Index: #{batch_index})" }

        if batch_depleted?
          resupply
        end

        message_data = batch[batch_index]

        logger.debug(tags: [:data, :message_data]) { "Next message data: #{message_data.pretty_inspect}" }
        logger.debug { "Done getting next message data (Batch Length: #{(batch &.length).inspect}, Batch Index: #{batch_index})" }

        advance_batch_index

        message_data
      end

      def resupply
        logger.trace { "Resupplying batch (Current Batch Length: #{(batch &.length).inspect})" }

        batch = []
        unless stream_depleted?
          batch = get_batch
        end

        reset(batch)

        logger.debug { "Batch resupplied (Next Batch Length: #{(batch &.length).inspect})" }
      end

      def get_batch
        position = next_batch_starting_position

        logger.trace "Getting batch (Position: #{position.inspect})"

        batch = get.(position)

        logger.debug { "Finished getting batch (Count: #{batch.length}, Position: #{position.inspect})" }

        batch
      end

      def next_batch_starting_position
        if not batch_initialized?
          logger.debug { "Batch is not initialized (Next batch starting position: #{starting_position.inspect})" }
          return starting_position
        end

        previous_position = last_position
        next_position = previous_position + 1
        logger.debug { "End of batch (Next starting position: #{next_position}, Previous Position: #{previous_position})" }

        next_position
      end

      def last_position
        get.last_position(batch)
      end

      def reset(batch)
        logger.trace { "Resetting batch" }

        self.batch = batch
        self.batch_index = 0

        logger.debug(tags: [:data, :batch]) { "Batch set to: \n#{batch.pretty_inspect}" }
        logger.debug(tags: [:data, :batch]) { "Batch position set to: #{batch_index.inspect}" }
        logger.debug { "Done resetting batch" }
      end

      def advance_batch_index
        logger.trace { "Advancing batch index (Batch Index: #{batch_index})" }
        self.batch_index += 1
        logger.debug { "Advanced batch index (Batch Index: #{batch_index})" }
      end

      def batch_initialized?
        not batch.nil?
      end

      def batch_depleted?
        if not batch_initialized?
          logger.debug { "Batch is depleted (Batch is not initialized)" }
          return true
        end

        if batch.empty?
          logger.debug { "Batch is depleted (Batch is empty)" }
          return true
        end

        if batch_index == batch.length
          logger.debug { "Batch is depleted (Batch Index: #{batch_index}, Batch Length: #{batch.length})" }
          return true
        end

        logger.debug { "Batch is not depleted (Batch Index: #{batch_index}, Batch Length: #{batch.length})" }
        false
      end

      def stream_depleted?
        if not batch_initialized?
          logger.debug { "Stream is not depleted (Batch Length: (batch is nil), Batch Size: #{batch_size})" }
          return false
        end

        if batch.length < batch_size
          logger.debug { "Stream is depleted (Batch Length: #{batch.length}, Batch Size: #{batch_size})" }
          return true
        end

        logger.debug { "Stream is not depleted (Batch Length: #{batch.length}, Batch Size: #{batch_size})" }
        false
      end

## Need not exist?
      class Substitute < Iterator
##        include Read::Iterator

        def self.build()
          new
        end
      end
    end
  end
end
