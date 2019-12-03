module MessageStore
  module Postgres
    module Get
      class Category
        Error = Class.new(RuntimeError)

        include Get

        initializer :category, na(:batch_size), :correlation, :consumer_group_member, :consumer_group_size, :condition
        alias :stream_name :category

        def self.call(category, position: nil, batch_size: nil, correlation: nil, consumer_group_member: nil, consumer_group_size: nil, condition: nil, session: nil)
          instance = build(category, batch_size: batch_size, correlation: correlation, consumer_group_member: consumer_group_member, consumer_group_size: consumer_group_size, condition: condition, session: session)
          instance.(position)
        end

        def self.build(category, batch_size: nil, correlation: nil, consumer_group_member: nil, consumer_group_size: nil, condition: nil, session: nil)
          instance = new(category, batch_size, correlation, consumer_group_member, consumer_group_size, condition)
          instance.configure(session: session)
          instance
        end

        def self.configure(receiver, category, attr_name: nil, batch_size: nil, correlation: nil, consumer_group_member: nil, consumer_group_size: nil, condition: nil, session: nil)
          attr_name ||= :get
          instance = build(category, batch_size: batch_size, correlation: correlation, consumer_group_member: consumer_group_member, consumer_group_size: consumer_group_size, condition: condition, session: session)
          receiver.public_send("#{attr_name}=", instance)
        end

        def configure(session: nil)
          Session.configure(self, session: session)
        end

        def sql_command
          "SELECT * FROM get_category_messages(#{parameters});"
        end

        def parameters
          '$1::varchar, $2::bigint, $3::bigint, $4::varchar, $5::bigint, $6::bigint, $7::varchar'
        end

        def parameter_values(category, position)
          [
            category,
            position,
            batch_size,
            correlation,
            consumer_group_member,
            consumer_group_size,
            condition
          ]
        end

        def last_position(batch)
          batch.last.global_position
        end

        def specialize_error(error_message)
          if error_message.start_with?('Correlation must be a category')
            return MessageStore::Postgres::Get::Category::Correlation::Error
          end

          if error_message.start_with?('Consumer group size must not be less than 1') ||
              error_message.start_with?('Consumer group member must be less than the group size') ||
              error_message.start_with?('Consumer group member must not be less than 0') ||
              error_message.start_with?('Consumer group member and size must be specified')
            return MessageStore::Postgres::Get::Category::ConsumerGroup::Error
          end
        end

        def log_text(category, position)
          "Category: #{category}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect}, Correlation: #{correlation.inspect}, Consumer Group Member: #{consumer_group_member.inspect}, Consumer Group Size: #{consumer_group_size.inspect}, Condition: #{condition.inspect})"
        end

        def assure
          if not MessageStore::StreamName.category?(category)
            raise Error, "Must be a category (Stream Name: #{category})"
          end
        end

        module Defaults
          def self.position
            1
          end
        end
      end
    end
  end
end
