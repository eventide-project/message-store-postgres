Read.(category: category_stream_name, poll_milliseconds: 500) do |event_data|
  # ...
end


Poll.(delay_milliseconds: 500, timeout_milliseconds: 5000) do |poll_controller|
  Read.(category: category_stream_name)
  # has to decide how and whether to poll again
  # if result is a nil, then it has to poll
  # internally, poll tracks iterations, timeout. does reset of timeout, etc

end


# Maybe an internal poll control?

  res = get_events ...

  if res.nil? && poll? # <- poll milliseconds are set
  end

