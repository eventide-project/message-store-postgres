require_relative '../../automated_init'

context "Iterator" do
  context "No further event data" do
    stream_name = Controls::Put.(instances: 2)

    get = Get.build

    iterator = Iterator.build(get, stream_name)

    2.times { iterator.next }

    last = iterator.next

    test "Results in nil" do
      assert(last.nil?)
    end
  end
end
