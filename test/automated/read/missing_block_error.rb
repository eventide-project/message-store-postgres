require_relative '../automated_init'

context "Read" do
  context "No block supplied" do
    test "Is incorrect" do
      assert proc { Read.(stream_name: 'some_stream_name') } do
        raises_error? Read::Error
      end
    end
  end
end
