module EventStream
  module Postgres
    class Write
      class ExpectedVersionError < RuntimeError; end
    end
  end
end
