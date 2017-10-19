require_relative '../automated_init'

context "Select Statement" do
  context "Condition" do
    stream_name = Controls::StreamName.example

    condition = '1 = 1'

    select_statement = Get::SelectStatement.build(stream_name, condition: condition)

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "Where Clause" do
      test "Filters on stream name" do
        assert(sql.include? 'WHERE stream_name =')
      end

      test "Filters on position" do
        assert(sql.include? 'position >=')
      end

      test "Includes condition encased in parentheses" do
        assert(sql.include? "AND (#{condition})")
      end
    end
  end
end
