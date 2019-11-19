require_relative '../../../automated_init'

context "Get" do
  context "Category" do
    context "Consumer Group" do


      message_data_group_0 = Get.(category, consumer_group_member: 0, consumer_group_size: 2)
      message_data_group_1 = Get.(category, consumer_group_member: 1, consumer_group_size: 2)






    end
  end
end
