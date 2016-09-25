require 'securerandom'
require 'http_eventstore'
require 'active_support/core_ext/array'

# Process message
class MessageProcessor
  
  def initialize
    @client = HttpEventstore::Connection.new 
  end

  def process_message(message)
    puts "Receieved message #{message.id}"
    product_ids = get_product_ids(message)

    product_ids.in_groups_of(5, false).each_with_index do |group, index|
      if index < 2
        stream_name = "inventory"
        event_data = { event_type: "InventoryItemUpdated",
                       data: { product_ids: group },
                       metadata: { "$correlationId": message.id,
                                    "$causationId": message.id },
                       event_id: SecureRandom.uuid }
        puts "Processed ids #{group.join(',')}"
        puts "Publishing event #{event_data}"
        client.append_to_stream(stream_name, event_data)
      else
        puts "Could not process ids #{group.join(',')}"
        raise "Some Error"
      end
    end

  end

  private

  attr_reader :client

  def get_product_ids(message)
    # Here we would query the event store by the message id
    # to find all events that may have completed.
    # the completed event product_ids would be removed 
    # from the original message, to resume the updates
    message.product_ids
  end
end

PRODUCT_IDS = (0..20).to_a
MESSAGE_ID = SecureRandom.uuid

message_processor = MessageProcessor.new
Message = Struct.new(:id, :product_ids)
retry_count = 0

begin
  message_processor.process_message(message = Message.new(MESSAGE_ID, PRODUCT_IDS))
rescue RuntimeError => e
  if retry_count > 3
    puts "Dead letter message, couldnt process message #{message.id}"
  else
    retry_count += 1
    retry
  end
end
