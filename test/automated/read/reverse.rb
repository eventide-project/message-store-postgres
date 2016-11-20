require_relative '../automated_init'

context "Read" do
  context "Reverse" do
    stream_name = Controls::Put.(instances: 3)

    events = []
    Read.(stream_name, precedence: :desc) do |event|
      events << event
    end

    first_event_postition = events.first.position

    test "Last event written is first in the list of results" do
      assert(first_event_postition == 2)
    end
  end
end
