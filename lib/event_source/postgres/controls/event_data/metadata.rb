module EventStream
  module Postgres
    module Controls
      module EventData
        module Metadata
          def self.data
            {
              some_meta_attribute: 'some meta value'
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
end
