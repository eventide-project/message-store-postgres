module MessageStore
  module Postgres
    module Get
      class Category
        include Get

        def self.command_text(parameters)
          "SELECT * FROM get_category_messages(#{parameters});"
        end

        def last_position(batch)
          batch.last.global_position
        end
      end
    end
  end
end
