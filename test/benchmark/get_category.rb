require_relative 'benchmark_init'

defaults = Test::Benchmark::Defaults.build

puts
puts "Get Category Benchmark (#{__FILE__})"
puts

puts "» defaults"
puts defaults.to_s
puts

total_cycles = defaults.total_cycles

puts "» constructing #{total_cycles} entries"
list = Controls::MessageData::Write::List.get(instances: total_cycles, category: defaults.stream_name)

put = Put.build

puts "» writing entries"
list.each do |entry|
  if defaults.verbose
    puts "Stream: #{entry.stream_name}, Category: #{entry.category}"
  end

  put.(entry.message_data, entry.stream_name)
end

puts "» constructing Get::Category"
get = Get::Category.build('', batch_size: 1)

puts "» executing and sampling #{total_cycles} cycles"
result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = list[i]

  if defaults.verbose
    puts "Getting Category: #{entry.category}"
  end

  get.(0, stream_name: entry.category)
end

puts
filename = Benchmark::RecordResult.('Get Category Benchmark', result)
puts
puts filename
puts
