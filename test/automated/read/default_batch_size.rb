require_relative '../automated_init'

context "Read" do
  context "Default batch Size" do
    default_batch_size = MessageStore::Read::Defaults.batch_size

    test "Is the Get implementation's default batch size" do
      assert(default_batch_size == MessageStore::Get::Defaults.batch_size)
    end
  end
end
