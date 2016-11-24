require_relative '../automated_init'

context "Select Statement" do
  context "Stream Name Query" do
    stream_name = Controls::StreamName.example

    select_statement = Get::SelectStatement.build(stream_name)

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "Where Clause" do
      test "Filters on stream name" do
        assert(sql.include? 'WHERE stream_name =')
      end
    end
  end
end
