module MessageStore
  module MessageData
    class Read
      include MessageData

      attribute :stream_name, String
      attribute :position, Integer
      attribute :global_position, Integer
      attribute :time, Time
    end
  end
end
