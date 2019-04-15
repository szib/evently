# ========================================
#    Event class
# ========================================

class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :attendances
  has_many :guests, through: :attendances

  validates :admin, :title, :date, :venue, presence: true
end
