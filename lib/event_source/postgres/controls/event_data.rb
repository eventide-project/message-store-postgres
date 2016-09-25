module EventStream
  module Postgres
    module Controls
      module EventData
        def self.type
          'SomeType'
        end

        def self.data
          { :some_attribute => 'some value' }
        end

        module JSON
          def self.data(id=nil)
            data = EventData.data
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
