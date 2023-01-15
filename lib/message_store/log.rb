module MessageStore
  class Log < ::Log
    def tag!(tags)
      tags << :message_store
    end
  end
end
