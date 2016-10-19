require_relative '../automated_init'

context "Read" do
  context "Synchronous Result" do
    res = Read.('some_stream_name') { }

    test "Returns a result that fails if actuated" do
      assert(res == AsyncInvocation::Incorrect)
    end
  end
end
