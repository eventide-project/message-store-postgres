require_relative '../automated_init'

controls = EventStream::Postgres::Controls

context "Select Statement" do
  context "Stream Name Query" do
    stream = controls::Stream.example

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
