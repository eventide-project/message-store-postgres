require_relative '../automated_init'

context "Select Statement" do
  context "Defaults" do
    stream = Controls::Stream.example

    select_statement = Get::SelectStatement.build stream

    context "Position" do
      default_position = Get::SelectStatement::Defaults.position
      test "#{default_position}" do
        assert(select_statement.position == default_position)
      end
    end

    context "Batch Size" do
      default_batch_size = Get::SelectStatement::Defaults.batch_size
      test "#{default_batch_size}" do
        assert(select_statement.batch_size == default_batch_size)
      end
    end
  end
end
