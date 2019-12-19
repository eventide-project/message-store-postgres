require_relative 'benchmark_init'

defaults = Test::Benchmark::Defaults.build

puts
puts "Get Stream Benchmark (#{__FILE__})"
puts

puts defaults.to_s
puts

puts "» constructing #{total_cycles} entries"
list = Controls::MessageData::Write::List.get(instances: defaults.total_cycles)

put = Put.build

puts "» writing entries"
list.each do |entry|
  stream_name = defaults.stream_name || entry.stream_name
  put.(entry.message_data, stream_name)
end

puts "» constructing Get::Stream"
get = Get::Stream.build(Controls::StreamName.example)

puts "» executing and sampling #{total_cycles} cycles"
result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]
  stream_name = defaults.stream_name || entry.stream_name
  get.(0, stream_name: stream_name)
end

puts
filename = Benchmark::RecordResult.('Get Stream Benchmark', result)
puts
puts filename
puts
