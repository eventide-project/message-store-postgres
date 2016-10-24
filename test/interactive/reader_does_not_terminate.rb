require_relative '../test_init'

Read.(stream_name: 'some_stream', batch_size: 1, delay_milliseconds: 200) { |event_data| }
