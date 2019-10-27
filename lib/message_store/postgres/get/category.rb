module MessageStore
  module Postgres
    module Get
      class Category
        include Get

        def self.sql_command
          "SELECT * FROM get_category_messages(#{parameters});"
        end

        def last_position(batch)
          batch.last.global_position
        end
      end
    end
  end
end
