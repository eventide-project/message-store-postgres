module MessageStore
  module Controls
    module MessageData
      module Metadata
        def self.data
          {
            meta_attribute: RandomValue.example
          }
        end

        module JSON
          def self.data(id=nil)
            data = Metadata.data
            Casing::Camel.(data, symbol_to_string: true)
          end

          def self.text
            data.to_json
          end
        end
      end
    end
  end
end
