require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Condition" do
      category = Controls::Category.example

      stream_name, _ = Controls::Put.(instances: 3, category: category)

      condition = 'position = 0 OR position = 2'

      settings = Postgres::Settings.build
      session = Session.new
      settings.set(session)
      session.options = '-c message_store.sql_condition=on'

      messages = Get::Category.(category, batch_size: 3, condition: condition, session: session)

      message_positions = messages.map do |message|
        message.position
      end

      test "Retrieves messages that meet the condition" do
        assert(message_positions == [0, 2])
      end
    end
  end
end
