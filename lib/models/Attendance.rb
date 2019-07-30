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
    return 'no friends' if num_of_extra_guests == 0
    return 'a friend' if num_of_extra_guests == 1

    "#{num_of_extra_guests} friends"
  end

  def guest_name_with_friends
    # returns e.g "Name + 5 friends"
    # returns e.g "Name + a friend"
    # returns e.g "Name" if no friends
    return guest.name.to_s if num_of_extra_guests == 0

    "#{guest.name} and #{friends_to_s}"
  end

  def num_of_extra_guests=(num)
    if num.between?(0, 9)
      super(num)
      save
    end
  end
end
