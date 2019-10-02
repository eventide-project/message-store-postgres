require_relative '../../automated_init'

context "Get" do
  context "Category" do
    context "Specialization" do
      stream_name = Controls::Category.example

      get = Get.build(stream_name)

      test "Get::Stream" do
        assert(get.instance_of?(Get::Category))
      end
    end
  end
end
