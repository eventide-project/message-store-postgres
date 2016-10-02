require_relative '../automated_init'

context "Select Statement" do
  context "Category Query" do
    stream = Controls::Stream::Category.example

    select_statement = Get::SelectStatement.build stream

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "Where Clause" do
      test "Filters on stream name" do
        assert(sql.include? 'WHERE category(stream_name) =')
      end
    end
  end
end
