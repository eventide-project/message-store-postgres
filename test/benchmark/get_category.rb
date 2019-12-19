require_relative 'benchmark_init'

defaults = Test::Benchmark::Defaults.build

puts
puts "Running benchmark (#{__FILE__})..."
puts


total_cycles = defaults.total_cycles

puts "- constructing #{total_cycles} entries"
list = Controls::MessageData::Write::List.get(instances: total_cycles)

##
pp list

put = Put.build

puts "- writing entries"
list.each do |entry|
  stream_name = defaults.stream_name || entry.stream_name
  put.(entry.message_data, stream_name)
end

category = Controls::Category.example

puts "- constructing Get::Category for #{category}"
get = Get::Category.build(category)

puts "- executing and sampling #{total_cycles} cycles"
result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]
  stream_name = MessageStore::StreamName.get_category(defaults.stream_name || entry.stream_name)

##
puts "- getting #{stream_name}"

  get.(0, stream_name: stream_name)
end

puts
filename = Benchmark::RecordResult.('Get Benchmark', result)
puts
puts filename
puts
