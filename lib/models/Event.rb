# ========================================
#    Event class
# ========================================

class Event < ActiveRecord::Base
  has_many :attendances
  has_many :guests, through: :attendances

  validates :title, :date, :venue, presence: true

  def num_of_attendees
    # including extra friends
    self.attendances.map { |a| a.number_of_guests }.sum
  end

  def self.to_menu_items(events)
    # returns a hash for prompt.select
    hash = {}
    events.each { |event| hash["#{event.title} (#{event.id})"] = event.id }
    hash
  end

  def attending?(guest)
    self.guests.include?(guest)
  end

  def toggle_attendance(guest)
    # add or remove attendance to the event
    # guest can signup for event or cancel attendance
    attendance = self.attendances.find { |a| a.guest == guest }
    if attendance
      attendance.destroy
      attendance = nil
    else
      attendance = Attendance.create(event: self, guest: guest)
    end
    attendance
  end

  def guest_list
    self.attendances.map do |attendance| 
      attendance.guest_name_with_friends
    end.join(", ")
  end

  def box_content
    lines = []
    lines << "Title:#{self.title}"
    lines << "Date: #{self.date}"
    lines << "Venue: #{self.venue}"
    lines << "Attendees: #{self.num_of_attendees}"
    lines << " "
    lines << "Description: #{self.description}"
    lines.join("\n")
  end

  def display
    box = TTY::Box.frame(
      width: 80,
      height: 15,
      align: :left,
      padding: 3,
      style: {
        fg: :bright_yellow,
        bg: :blue,
        border: {
          fg: :bright_yellow,
          bg: :blue
        }
      }
    ) do
      self.box_content
    end
    puts box
  end


end
