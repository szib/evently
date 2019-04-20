# ========================================
#    Event class
# ========================================

class Event < ActiveRecord::Base
  has_many :attendances
  has_many :guests, through: :attendances

  validates :title, :date, :venue, presence: true

  def num_of_attendees
    # including extra friends
    attendances.map(&:number_of_guests).sum
  end

  def self.to_menu_items(events)
    # returns a hash for prompt.select
    hash = {}
    events.each { |event| hash["#{event.title} (#{event.id})"] = event.id }
    hash
  end

  def toggle_attendance(guest)
    # add or remove attendance to the event
    # guest can signup for event or cancel attendance
    attendance = attendances.find { |a| a.guest == guest }
    if attendance
      attendance.destroy
      attendance = nil
    else
      attendance = Attendance.create(event: self, guest: guest)
    end
    attendance
  end

  def guest_list
    attendances.map(&:guest_name_with_friends).join(', ')
  end

  def event_info
    lines = []

    desc = description
    desc = desc.slice(0, 200) + '...' if desc.length > 200

    lines << "Title: #{title}"
    lines << "Date: #{date}"
    lines << "Venue: #{venue}"
    lines << "Attendees: #{num_of_attendees}"
    lines << ' '
    lines << 'Description:'
    lines << desc
    lines.join("\n")
  end

  def attendance_info_of(guest)
    attendance = attendances.find { |attendance| attendance.guest == guest }
    if attendance
      "You are attending this event and bringing #{attendance.friends_to_s}."
    else
      'You are not attending this event.'
    end
  end
end
