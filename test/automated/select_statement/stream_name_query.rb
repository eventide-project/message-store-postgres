require_relative '../automated_init'

context "Select Statement" do
  context "Stream Name Query" do
    stream = Controls::Stream.example

    select_statement = Get::SelectStatement.build stream

    sql = select_statement.sql
    sql.gsub!(/\s+/, " ")

    context "Where Clause" do
      test "Filters on stream name" do
        assert(sql.include? 'WHERE stream_name =')
      end
    end
  end
end
