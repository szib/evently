# ========================================
#    Administrator class
# ========================================

class Admin < ActiveRecord::Base
  has_many :events
end
