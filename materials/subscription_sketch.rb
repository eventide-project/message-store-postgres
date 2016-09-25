# Timeout and retry

retry.() do
  loop do
    get_batch

    if no_batch
      break unless timeout.nil? # maybe raise Timeout::Error

      sleep timeout
    end
  end
end
