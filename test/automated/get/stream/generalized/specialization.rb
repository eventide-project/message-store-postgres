require_relative '../../../automated_init'

context "Get" do
  context "Stream" do
    context "Generalized" do
      context "Specialization" do
        stream_name = Controls::StreamName.example

        batch_size = 1
        correlation = 'someCorrelation'
        consumer_group_member = 0
        consumer_group_size = 1
        condition = 'global_position >= 1'
        session = Session.build

        get = Get.build(stream_name, batch_size: batch_size, correlation: correlation, condition: condition, session: session)

        context "Type" do
          test "Get::Stream" do
            assert(get.instance_of?(Get::Stream))
          end
        end

        context "Attributes" do
          test "stream_name" do
            assert(get.stream_name == stream_name)
          end

          test "batch_size" do
            assert(get.batch_size == batch_size)
          end

          test "correlation" do
            assert(get.correlation == correlation)
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
end
