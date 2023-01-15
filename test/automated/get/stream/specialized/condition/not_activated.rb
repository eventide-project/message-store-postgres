require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Specialized" do
      context "Condition" do
        context "Not Activated" do
          stream_name = Controls::StreamName.example

          condition = 'some condition'

          settings = MessageStore::Settings.build
          session = Session.new
          settings.set(session)
          session.options = nil

          test "Is an error" do
            assert_raises(Get::Condition::Error) do
              Get.(stream_name, batch_size: 3, condition: condition, session: session)
            end
          end
        end
      end
    end
  end
end
