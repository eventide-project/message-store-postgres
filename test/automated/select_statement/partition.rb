require_relative '../automated_init'

context "Select Statement" do
  context "Partition" do
    stream = Controls::Stream.example

    select_statement = Get::SelectStatement.build stream, partition: Controls::Partition.example

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "From Clause" do
      test "Partition table name" do
        assert(sql.include? "FROM #{Controls::Partition.example}")
      end
    end
  end
end
