module EventStream
  module Postgres
    module Controls
      module EventData
        module Hash
          def self.data
            {
              some_attribute: 'some value'
            }
          end

          def self.example
            EventStream::Postgres::EventData::Hash[data]
          end

          module JSON
            def self.data(id=nil)
              data = Hash.data
              Casing::Camel.(data, symbol_to_string: true)
            end

            def self.text
              ::JSON.generate(data)
            end
          end
        end
      end
    end
  end
end
