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

  def friends_to_s
    if self.num_of_extra_guests == 0
      return "no friends"
    elsif self.num_of_extra_guests == 1
      return "a friend"
    else
      return "#{self.num_of_extra_guests} friends"
    end
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

  def change_num_of_friends(num)
    return false if num < 0 || num > 10
    self.num_of_extra_guests = num
    self.save
  end

end
