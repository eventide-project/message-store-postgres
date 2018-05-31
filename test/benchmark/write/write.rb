require_relative '../benchmark_init'

defaults = Benchmark::Defaults.build

puts
puts 'Write Benchmark'
puts '- - -'

list = Controls::MessageData::Write::List.get(instances: defaults.total_cycles)

write = Write.build

result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]
  write.(entry.message_data, entry.stream_name)
end

puts result
puts
