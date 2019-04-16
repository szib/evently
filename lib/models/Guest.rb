# ========================================
#    Guest class
# ========================================

class Guest < ActiveRecord::Base
  has_many :attendances
  has_many :events, through: :attendances

  validates :name, presence: true

  def upcoming_events(days:)
    # list guest's events in the next :days day
  end

  def past_events
    # list guest's past events
  end
end
