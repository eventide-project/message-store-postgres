require_relative '../automated_init'

context "Get" do
  context "No Events" do
    stream = Controls::Stream.example

    batch = Get.(stream)

    test "Empty array" do
      assert(batch == [])
    end
  end
end
