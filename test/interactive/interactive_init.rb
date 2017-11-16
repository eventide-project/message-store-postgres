ENV['LOG_LEVEL'] ||= 'info'
ENV['LOG_TAGS'] ||= '_untagged,message_store_postgres,-data'

require_relative '../test_init'
