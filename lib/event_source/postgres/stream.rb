module EventStream
  module Postgres
    class Stream
      class NameError < RuntimeError; end

      initializer :stream_name, :category, :type

      def name
        if type == :stream
          return stream_name
        else
          return category
        end
      end

      def self.build(stream_name: nil, category: nil)
        stream_name, category, type = get_name(stream_name, category)
        new stream_name, category, type
      end

      def self.get_name(stream_name, category)
        if !stream_name.nil? && !category.nil?
          raise NameError, "Both stream stream_name and category are specified. Specify one or the other."
        end

        type = nil
        if !stream_name.nil?
          category = StreamName.category(stream_name)
          type = :stream
        else
          stream_name = category
          type = :category
        end

        if stream_name.nil? && category.nil?
          raise NameError, "Neither stream name nor category are specified. Specify one or the other."
        end

        return stream_name, category, type
      end
    end
  end
end
