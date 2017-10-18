require_relative '../automated_init'

context "Select Statement" do
  context "Where Fragment" do
    stream_name = Controls::StreamName.example

    where_fragment = '1 = 1'

    select_statement = Get::SelectStatement.build(stream_name, where_fragment: where_fragment)

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "Where Clause" do
      test "Filters on stream name" do
        assert(sql.include? 'WHERE stream_name =')
      end

      test "Filters on position" do
        assert(sql.include? 'position >=')
      end

      test "Includes where fragment encased in parentheses" do
        assert(sql.include? "AND (#{where_fragment})")
      end
    end
  end
end
