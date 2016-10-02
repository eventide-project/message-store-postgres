require_relative '../automated_init'

Controls = EventSource::Postgres::Controls

context "Select Statement" do
  context "Defaults" do
    stream = Controls::Stream.example

    select_statement = Get::SelectStatement.build stream

    context "Offset" do
      default_offset = Get::SelectStatement::Defaults.offset
      test "#{default_offset}" do
        assert(select_statement.offset == default_offset)
      end
    end

    context "Batch Size" do
      default_batch_size = Get::SelectStatement::Defaults.batch_size
      test "#{default_batch_size}" do
        assert(select_statement.batch_size == default_batch_size)
      end
    end

    context "Precedence" do
      default_precedence = Get::SelectStatement::Defaults.precedence
      test "#{default_precedence}" do
        assert(select_statement.precedence == default_precedence)
      end
    end
  end
end
