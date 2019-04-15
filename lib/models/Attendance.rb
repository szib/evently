# ========================================
#    Attendance class
# ========================================

class Attendance < ActiveRecord::Base
  belongs_to :guest
  belongs_to :event

  validates :guest, :event, presence: true
end
