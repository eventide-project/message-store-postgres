require_relative '../automated_init'

context "Select Statement" do
  context "Category Query" do
    category = Controls::Category.example

    select_statement = Get::SelectStatement.build(category)

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "Where Clause" do
      test "Filters on stream name" do
        assert(sql.include? 'WHERE category(stream_name) =')
      end
    end
  end
end
