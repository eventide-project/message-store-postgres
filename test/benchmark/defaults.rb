module Test
  module Benchmark
    class Defaults
      initializer :cycles, :warmup_cycles, :gc, :stream_name

      def total_cycles
        cycles + warmup_cycles
      end

      def to_s
        <<~TEXT
          Cycles: #{cycles}
          Warmup Cycles: #{warmup_cycles}
          GC: #{gc}
          Stream Name: #{stream_name.inspect}
        TEXT
      end

      def self.build
        new(cycles, warmup_cycles, gc, stream_name)
      end

      def self.cycles
        Integer(ENV['CYCLES'] || 100_000)
      end

      def self.warmup_cycles
        Integer(ENV['WARMUP_CYCLES'] || 10)
      end

      def self.gc
        ['on', 'true'].include?(ENV['GC']) ? true : false
      end

      def self.stream_name
        ENV['STREAM_NAME'] || Controls::StreamName.example
      end
    end
  end
end
