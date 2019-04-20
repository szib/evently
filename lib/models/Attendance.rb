# ========================================
#    Attendance class
# ========================================

class Attendance < ActiveRecord::Base
  belongs_to :guest
  belongs_to :event

  validates :guest, :event, presence: true

  def number_of_guests
    num_of_extra_guests + 1
  end

  def friends_to_s
    if num_of_extra_guests == 0
      'no friends'
    elsif num_of_extra_guests == 1
      'a friend'
    else
      "#{num_of_extra_guests} friends"
    end
  end

  def guest_name_with_friends
    # returns e.g "Name + 5 friends"
    # returns e.g "Name + a friend"
    # returns e.g "Name" if no friends
    if num_of_extra_guests == 0
      guest.name.to_s
    elsif num_of_extra_guests == 1
      "#{guest.name} + a friend"
    else
      "#{guest.name} + #{num_of_extra_guests} friends"
    end
  end

  def num_of_extra_guests=(num)
    if num.between?(1, 10)
      super(num)
      save
    end
  end
end
