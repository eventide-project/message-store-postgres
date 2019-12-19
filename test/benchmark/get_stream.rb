require_relative 'benchmark_init'

defaults = Test::Benchmark::Defaults.build

puts
puts "Get Stream Benchmark (#{__FILE__})"
puts

puts "» defaults"
puts defaults.to_s
puts

total_cycles = defaults.total_cycles

puts "» constructing #{total_cycles} entries"
list = Controls::MessageData::Write::List.get(instances: total_cycles, stream_name: defaults.stream_name)

put = Put.build

puts "» writing entries"
list.each do |entry|
  stream_name = defaults.stream_name || entry.stream_name

  if defaults.verbose
    puts "Stream: #{stream_name}"
  end

  put.(entry.message_data, stream_name)
end

puts "» constructing Get::Stream"
get = Get::Stream.build('-')

puts "» executing and sampling #{total_cycles} cycles"
result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]

  if defaults.verbose
    puts "Getting: #{entry.stream_name}"
  end

  stream_name = defaults.stream_name || entry.stream_name
  get.(0, stream_name: stream_name)
end

puts
filename = Benchmark::RecordResult.('Get Stream Benchmark', result)
puts
puts filename
puts
