require_relative '../automated_init'

context "Session" do
  context "Escape" do
    session = Session.build

    unescaped_data = "'"
    control_data = "''"

    escaped_data = session.escape(unescaped_data)

    context "Escaped Data" do
      comment escaped_data.inspect
      detail "Control Data: #{control_data.inspect}"
      detail "Unescaped Data: #{unescaped_data.inspect}"

      test "escaped_Data is escaped" do
        assert(escaped_data == control_data)
      end
    end
  end
end
