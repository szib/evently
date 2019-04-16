# ========================================
#    Event class
# ========================================

class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :attendances
  has_many :guests, through: :attendances

  validates :admin, :title, :date, :venue, presence: true

  def num_of_attendees
    # including extra friends
    self.attendances.map { |a| a.number_of_guests }.sum
  end

  def display
    pastel = Pastel.new
    puts '-' * 40
    puts pastel.yellow(title)
    puts '-' * 40
    puts description
    puts pastel.cyan("\tDate:\t #{date}")
    puts pastel.cyan("\tVenue:\t #{venue}")
    puts pastel.cyan("\tAttendees:\t #{self.num_of_attendees}")
    puts '-' * 40
    attendees = self.attendances.map { |a| a.guest_name_with_friends }.join(", ")
    puts pastel.green(attendees)
  end

  def self.to_menu_items(events: events)
    # returns a hash for prompt.select
    hash = {}
    events.each { |event| hash["#{event.title} (#{event.id})"] = event.id }
    hash
  end

  def attending?(guest)
    self.guests.include?(guest)
  end

end
