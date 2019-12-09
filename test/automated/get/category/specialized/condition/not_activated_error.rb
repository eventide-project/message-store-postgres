require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Specialized" do
      context "Condition" do
        context "Condition Is Not Activated" do
          category = Controls::Category.example

          condition = 'some condition'

          settings = Postgres::Settings.build
          session = Session.new
          settings.set(session)
          session.options = nil

          test "Is an error" do
            assert_raises(Get::Condition::Error) do
              Get::Category.(category, batch_size: 3, condition: condition, session: session)
            end
          end
        end
      end
    end
  end
end
