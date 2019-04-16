# ========================================
#    Attendance class
# ========================================

class Attendance < ActiveRecord::Base
  belongs_to :guest
  belongs_to :event

  validates :guest, :event, presence: true

  def number_of_guests
    self.num_of_extra_guests + 1
  end

  def guest_name_with_friends
    # returns e.g "Name + 5 friends"
    # returns e.g "Name + a friend"
    # returns e.g "Name" if no friends
    if self.num_of_extra_guests == 0
      return "#{self.guest.name}"
    elsif self.num_of_extra_guests == 1
      return "#{self.guest.name} + a friend"
    else
      return "#{self.guest.name} + #{self.num_of_extra_guests} friends"
    end
  end

  def self.toggle_attendance(event:, guest:)
    # add or remove attendance to the event
    # guest can signup for event or cancel attendance
    attending = Attendance.find_by(event: event, guest: guest)
    if attending.is_a?(Attendance)
      attending.destroy
      return nil
    else
      Attendance.create(event: event, guest: guest)
    end
  end

  def change_num_of_friends(num)
    self.num_of_extra_guests = num
    self.save
  end

end
