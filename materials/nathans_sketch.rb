class PostgresqlReader
  attr_writer :batch
  attr_writer :position

  def initialize(category)
    @category = category
  end

  # Implementing the reader as a  pull system
  def next
    row = pg.execute "SELECT * FROM events WHERE position = ? AND category = ?", position, category

    position += 1

    event_data = Serialize::Read.(row, :postgresql, EventData)

    event_data
  end

  # the pull system (actuated via #next) easily can become a push system.
  # The inverse, going from push to pull, requires synchronization via
  # eg fibers, Enumerable::Lazy. etc.
  def start(&block)
    loop do
      event_data = self.next
      block.(event_data)
    end
  end

  def position
    @position ||= 0
  end
end
