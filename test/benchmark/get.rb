require_relative 'benchmark_init'

defaults = Benchmark::Defaults.build

puts
puts 'Get Benchmark'
puts '- - -'

list = Controls::MessageData::Write::List.get(instances: defaults.total_cycles)

put = Put.build

list.each do |entry|
  put.(entry.message_data, entry.stream_name)
end

get = Get.build

result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]
  get.(entry.stream_name)
end

puts result
puts
