module MessageStore
  module Controls
    module Time
      def self.example(time=nil)
        time ||= Raw.example
        ISO8601.example(time)
      end

      module Raw
        def self.example
          Clock::Controls::Time::Raw.example
        end
      end

      module ISO8601
        def self.example(time=nil)
          Clock::Controls::Time::ISO8601.example(time)
        end

        def self.precision
          3
        end
      end

      module Processed
        def self.example(time=nil, offset_milliseconds: nil)
          offset_milliseconds ||= self.offset_milliseconds
          Clock::Controls::Time::Offset.example(offset_milliseconds, time: time, precision: ISO8601.precision)
        end

        module Raw
          def self.example(time=nil, offset_milliseconds: nil)
            offset_milliseconds ||= Processed.offset_milliseconds
            Clock::Controls::Time::Offset::Raw.example(offset_milliseconds, time: time, precision: ISO8601.precision)
          end
        end

        def self.offset_milliseconds
          11
        end
      end

      module Effective
        def self.example(time=nil, offset_milliseconds: nil)
          offset_milliseconds ||= self.offset_milliseconds
          Clock::Controls::Time::Offset.example(offset_milliseconds, time: time, precision: ISO8601.precision)
        end

        module Raw
          def self.example(time=nil, offset_milliseconds: nil)
            offset_milliseconds ||= Effective.offset_milliseconds
            Clock::Controls::Time::Offset::Raw.example(offset_milliseconds, time: time, precision: ISO8601.precision)
          end
        end

        def self.offset_milliseconds
          1
        end
      end
    end
  end
end
