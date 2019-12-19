require_relative 'benchmark_init'

defaults = Test::Benchmark::Defaults.build

puts
puts "Put Benchmark (#{__FILE__})"
puts

puts "» defaults"
puts defaults.to_s
puts

total_cycles = defaults.total_cycles

puts "» constructing #{total_cycles} entries"
list = Controls::MessageData::Write::List.get(instances: total_cycles, stream_name: defaults.stream_name)

put = Put.build

result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]

  if defaults.verbose
    puts "Putting Stream: #{entry.stream_name}"
  end

  put.(entry.message_data, entry.stream_name)
end

puts
filename = Benchmark::RecordResult.('Put Benchmark', result)
puts
puts filename
puts
