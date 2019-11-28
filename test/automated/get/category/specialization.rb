require_relative '../../automated_init'

context "Get" do
  context "Category" do
    context "Specialization" do
      category = Controls::Category.example
      batch_size = 1
      correlation = 'someCorrelation'
      consumer_group_member = 0
      consumer_group_size = 1
      condition = 'global_position >= 1'
      session = Session.build

      get = Get.build(category, batch_size: batch_size, correlation: correlation, consumer_group_member: consumer_group_member, consumer_group_size: consumer_group_size, condition: condition, session: session)

      context "Type" do
        test "Get::Category" do
          assert(get.instance_of?(Get::Category))
        end
      end

      context "Attributes" do
        test "category" do
          assert(get.category == category)
        end

        test "batch_size" do
          assert(get.batch_size == batch_size)
        end

        test "correlation" do
          assert(get.correlation == correlation)
        end

        test "consumer_group_member" do
          assert(get.consumer_group_member == consumer_group_member)
        end

        test "consumer_group_size" do
          assert(get.consumer_group_size == consumer_group_size)
        end

        test "condition" do
          assert(get.condition == condition)
        end

        test "session" do
          assert(get.session == session)
        end
      end
    end
  end
end
