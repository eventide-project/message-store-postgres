require_relative '../../../automated_init'

context "Get" do
  context "Category" do
    context "Generalized" do
      context "Get Messages" do
        category = Controls::Category.example

        Controls::Put.(category: category)
        Controls::Put.(category: category)

        message_data = Get.(category)

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
