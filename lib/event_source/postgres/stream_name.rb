module EventStream
  module Postgres
    module StreamName
      extend self

      def stream_name(category_name, id=nil)
        id ||= Identifier::UUID.random

        "#{category_name}-#{id}"
      end

      def category_stream_name(category_name)
        category_name
      end

      def self.get_id(stream_name)
        Identifier::UUID.parse(stream_name)
      end

      def self.category(stream_name)
        stream_name.split('-').first
      end
    end
  end
end
