require_relative '../../automated_init'

context "Get" do
  context "Stream" do
    context "Specialization" do
      stream_name = Controls::StreamName.example

      get = Get.build(stream_name)

      test "Get::Stream" do
        assert(get.instance_of?(Get::Stream))
      end
    end
  end
end
