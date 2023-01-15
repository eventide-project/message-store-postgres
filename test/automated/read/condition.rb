require_relative '../automated_init'

context "Read" do
  context "Condition" do
    stream_name, _ = Controls::Put.(instances: 3)

    condition = 'position = 0'

    message_count = 0

    settings = MessageStore::Settings.build
    session = Session.new
    settings.set(session)
    session.options = '-c message_store.sql_condition=on'

    Read.(stream_name, condition: condition, session: session) do
      message_count += 1
    end

    test "Reads messages that meet condition" do
      assert(message_count == 1)
    end
  end
end
