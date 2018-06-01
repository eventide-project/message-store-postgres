require_relative 'benchmark_init'

defaults = Benchmark::Defaults.build

list = Controls::MessageData::Write::List.get(instances: defaults.total_cycles)

put = Put.build

result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]
  put.(entry.message_data, entry.stream_name)
end

Benchmark::RecordResult.('Put Benchmark', result)
