module EventStream
  module Postgres
    class EventData
      class Hash < ::Hash
        module Serializer
          def self.json
            JSON
          end

          def self.instance(raw_data)
            Hash[raw_data]
          end

          def self.raw_data(instance)
            Hash[instance]
          end

          module JSON
            def self.serialize(raw_hash_data)
              json_formatted_data = Casing::Camel.(raw_hash_data)
              ::JSON.generate(json_formatted_data)
            end

            def self.deserialize(text)
              json_formatted_data = ::JSON.parse(text, :symbolize_names => true)
              Casing::Underscore.(json_formatted_data)
            end
          end
        end
      end
    end
  end
end
