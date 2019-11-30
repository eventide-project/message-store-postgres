require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Correlation" do
      correlation_category = Controls::Category.example

      correlation_stream_name = Controls::StreamName.example(category: correlation_category)

      correlation_metadata = {
        correlation_stream_name: correlation_stream_name
      }

      category = Controls::Category.example

      message_data = Controls::MessageData::Write.example

      message_data.metadata = {
        correlation_stream_name: SecureRandom.hex
      }

      stream_name = Controls::StreamName.example(category: category)
      Put.(message_data, stream_name)

      2.times do
        message_data = Controls::MessageData::Write.example(metadata: correlation_metadata)
        stream_name = Controls::StreamName.example(category: category)
        Put.(message_data, stream_name)
      end

      message_datas = Get::Category.(category, correlation: correlation_category)

      correlation_stream_names = message_datas.map do |message_data|
        message_data.metadata[:correlation_stream_name]
      end

      test "Retrieves messages that meet the condition" do
        assert(correlation_stream_names == [correlation_stream_name, correlation_stream_name])
      end
    end
  end
end
