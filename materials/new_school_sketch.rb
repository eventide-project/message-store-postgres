# calls the handle method even if it doesn't exist
handler.send(message)

# only calls the handle method if it exists
handler.handle(message)

# Proposal: Just the reader and writer in the client library
# No messaging reader, subscription, or writer in the
# messaging library

Read.(stream: stream_name) do |event_data|
  dispatcher.(event_data)
end

# or the instance

reader.(stream: stream_name) do |event_data|
  dispatcher.(event_data)
end

# Note: no need for messaging reader above. The dispatcher
# is the place where deserialization is done right now.
# So there's no need for a Messaging::MessageReader.

# the handler is still in the dispatcher

class SomeDispatcher
  handler SomeHandler
end

# This is a subscription

Read.(category: category_stream_name, poll_milliseconds: 500) do |event_data|
  # ...
end

# Projection

# (from within the projection's instance code)
reader.(stream_name: stream_name) do |event_data|
  apply(event_data)
end

# In order to convert to/from event_data and message
# types, the reader needs to get a list of types
# So, message types can be had from anything that
# implements a message registry method, returning
# the existing implementation of a Message::Registry

message_classes = [
  SomeMessage,
  SomeOtherMessage
]

Read.(stream_name: stream_name) do |event_data|
  handler.(event_data)
  # handler has enough info about message classes that it can
  # xvert them
end

# The writer
# This converts to event_data
writer.(message)

# This doesn't need to convert to event_data
writer.(event_data)

# Or with the optional block
writer.(message) do |event_data|
  # do something with the event_data if wanted
  # this block is for transparency to the opaque event_data before it's saved
end

# Writer returns event_data, either way
event_data = writer.(message)
event_data = writer.(event_data)


# The writer's class actuator
Write.(message, message_classes)
  # why does this take message classes?
  # it does not de-serialize
