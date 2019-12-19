require_relative 'benchmark_init'

defaults = Test::Benchmark::Defaults.build

puts
puts "Get Category Benchmark (#{__FILE__})"
puts

puts "» defaults"
puts defaults.to_s

total_cycles = defaults.total_cycles
puts

puts "» constructing #{total_cycles} entries"
list = Controls::MessageData::Write::List.get(instances: total_cycles)

put = Put.build

puts "» writing entries"
list.each do |entry|
  stream_name = defaults.stream_name || entry.stream_name

  if defaults.verbose
    puts "Stream: #{stream_name}"
  end

  put.(entry.message_data, stream_name)
end

category = Controls::Category.example

puts "» constructing Get::Category"
get = Get::Category.build('')

puts "» executing and sampling #{total_cycles} cycles"
result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]
  stream_name = MessageStore::StreamName.get_category(defaults.stream_name || entry.stream_name)

##
puts "- getting #{stream_name}"

  get.(0, stream_name: stream_name)
end

puts
filename = Benchmark::RecordResult.('Get Category Benchmark', result)
puts
puts filename
puts
