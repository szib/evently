# ========================================
#    Guest class
# ========================================

class Guest < ActiveRecord::Base
  has_many :attendances
  has_many :events, through: :attendances

  validates :name, presence: true

  def new_events
    Event.all - events
  end
end
