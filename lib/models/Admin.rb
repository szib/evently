# ========================================
#    Administrator class
# ========================================

class Admin < ActiveRecord::Base
  has_many :events

  validates :name, presence: true
end
