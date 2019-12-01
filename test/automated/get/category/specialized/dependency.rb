require_relative '../../../automated_init'

context "Get" do
  context "Category" do
    context "Specialized" do
      context "Dependency" do
        category = Controls::Category.example

        Controls::Put.(category: category)
        Controls::Put.(category: category)

        receiver = OpenStruct.new

        Get::Category.configure(receiver, category)

        get = receiver.get

        message_data = get.()

        context "Messages Retrieved" do
          test "Messages from the all streams in the category" do
            assert(message_data.length == 2)
          end

          context "Message category is the category written" do
            message_data.each do |md|
              message_cateogry = StreamName.get_category(md.stream_name)

              test do
                assert(message_cateogry == category)
              end
            end
          end
        end
      end
    end
  end
end
