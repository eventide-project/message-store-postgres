require_relative '../benchmark_init'

defaults = Benchmark::Defaults.build

puts
puts 'Write Benchmark'
puts '- - -'

Entry = Struct.new(:stream_name, :message_data)

entries = []
defaults.total_cycles.times do
  stream_name = Controls::StreamName.example
  write_message = Controls::MessageData::Write.example

  entries << Entry.new(stream_name, write_message)
end

write = Write.build

result = Diagnostics::Sample.(defaults.cycles, warmup_cycles: defaults.warmup_cycles, gc: defaults.gc) do |i|
  entry = entries[i]
  write.(entry.message_data, entry.stream_name)
end

puts result
puts
