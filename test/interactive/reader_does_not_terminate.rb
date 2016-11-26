require_relative '../test_init'

stream_name = Controls::StreamName.example

Read.(stream_name, batch_size: 1, cycle_delay_milliseconds: 200) { |event_data| }
