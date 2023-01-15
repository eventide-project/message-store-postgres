## Add tests, this did not have tests in message-store either - Aaron, Sun Jan 15 2023
module MessageStore
  module Get
    class Substitute
      include Initializer
      include Virtual

      include Get

      attr_accessor :stream_name
      alias :category :stream_name

      def batch_size
        @batch_size ||= 1
      end
      attr_writer :batch_size

      def items
        @items ||= []
      end

      def self.build
        new
      end

      def call(position)
        position ||= 0

        logger.trace(tag: :get) { "Getting (Position: #{position}, Stream Name: #{stream_name.inspect}, Batch Size: #{batch_size})" }

        logger.debug(tag: :data) { "Items: \n#{items.pretty_inspect}" }
        logger.debug(tag: :data) { "Position: #{position.inspect}" }
        logger.debug(tag: :data) { "Batch Size: #{batch_size.inspect}" }

        # No specialized Gets for substitute
        # Complexity has to be inline for the control
        # Scott, Tue Oct 1 2019
        unless self.class.category_stream?(stream_name)
          index = (items.index { |i| i.position >= position })
        else
          index = (items.index { |i| i.global_position >= position })
        end

        logger.debug(tag: :data) { "Index: #{index.inspect}" }

        if index.nil?
          items = []
        else
          range = index..(index + batch_size - 1)
          logger.debug(tag: :data) { "Range: #{range.pretty_inspect}" }

          items = self.items[range]
        end

        logger.info(tag: :data) { "Got: \n#{items.pretty_inspect}" }
        logger.info(tag: :get) { "Finished getting (Position: #{position}, Stream Name: #{stream_name.inspect})" }

        items
      end

      def last_position(batch)
        if self.class.category_stream?(stream_name)
          batch.last.global_position
        else
          batch.last.position
        end
      end

      def self.category_stream?(stream_name)
        StreamName.category?(stream_name)
      end
    end
  end
end
