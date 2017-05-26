# module MessageStore
#   module Postgres
#     module Controls
#       StreamName = MessageStore::Controls::StreamName
#     end
#   end
# end

module MessageStore
  module Postgres
    module Controls
      module StreamName
        def self.example(category: nil, id: nil, type: nil, types: nil, randomize_category: nil)
          category ||= Category.example(category: category, randomize_category: randomize_category)
          id ||= Identifier::UUID.random

          MessageStore::Postgres::StreamName.stream_name(category, id, type: type, types: types)
        end
      end
    end
  end
end
