require_relative '../automated_init'

context "Select Statement" do
  context "Category Query" do
    category = Controls::Category.example

    select_statement = Get::SelectStatement.build(category)

    sql = select_statement.sql
    sql.gsub!(/\s+/, ' ')

    context "Where Clause" do
      test "Filters on category of stream name" do
        assert(sql.include? 'WHERE category(stream_name) =')
      end

      test "Filters on global position" do
        assert(sql.include? 'global_position >=')
      end
    end

    context "Order Clause" do
      test "Orders by the global position" do
        assert(sql.include? 'ORDER BY global_position')
      end
    end
  end
end
