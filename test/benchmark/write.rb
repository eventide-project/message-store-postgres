require_relative 'benchmark_init'
require 'benchmark'

warmup_cycles = 10
test_cycles = 10_000
cycles = warmup_cycles + test_cycles

Entry = Struct.new(:stream_name, :message_data)

entries = []
cycles.times do
  stream_name = Controls::StreamName.example
  write_message = Controls::MessageData::Write.example

  entries << Entry.new(stream_name, write_message)
end

session = Session.build
write = Write.build(session: session)

result = Diagnostics::Sample.(test_cycles, warmup_cycles: warmup_cycles, gc: true) do |i|
  entry = entries[i]
  write.(entry.message_data, entry.stream_name)
end

puts result
