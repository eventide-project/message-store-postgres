module Benchmark
  class Defaults
    initializer :cycles, :warmup_cycles, :gc

    def total_cycles
      cycles + warmup_cycles
    end

    def to_s
      <<~TEXT
        Cycles: #{cycles}
        Warmup Cycles: #{warmup_cycles}
        GC: #{gc}
      TEXT
    end

    def self.build
      new(cycles, warmup_cycles, gc)
    end

    def self.cycles
      Integer(ENV['CYCLES'] || 2500)
    end

    def self.warmup_cycles
      Integer(ENV['WARMUP_CYCLES'] || 10)
    end

    def self.gc
      ['on', 'true'].include?(ENV['GC']) ? true : false
    end
  end
end
