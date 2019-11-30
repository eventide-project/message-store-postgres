require_relative '../../../../automated_init'

context "Get" do
  context "Category" do
    context "Consumer Groups" do
      context "Error" do

        context "Consumer Group Size Is Less than 1" do
          test "Is an error" do
            assert_raises(Get::Category::ConsumerGroup::Error) do
              Get::Category.('someCategory', consumer_group_member: 0, consumer_group_size: 0)
            end
          end
        end

        context "Consumer Group Member Is Greater than the Consumer Group Size" do
          test "Is an error" do
            assert_raises(Get::Category::ConsumerGroup::Error) do
              Get::Category.('someCategory', consumer_group_member: 2, consumer_group_size: 1)
            end
          end
        end

        context "Consumer Group Member Is Less than 0" do
          test "Is an error" do
            assert_raises(Get::Category::ConsumerGroup::Error) do
              Get::Category.('someCategory', consumer_group_member: -1, consumer_group_size: 1)
            end
          end
        end

        context "Consumer Group Size is Missing" do
          test "Is an error" do
            assert_raises(Get::Category::ConsumerGroup::Error) do
              Get::Category.('someCategory', consumer_group_member: 0)
            end
          end
        end

        context "Consumer Group Member is Missing" do
          test "Is an error" do
            assert_raises(Get::Category::ConsumerGroup::Error) do
              Get::Category.('someCategory', consumer_group_size: 1)
            end
          end
        end
      end
    end
  end
end
