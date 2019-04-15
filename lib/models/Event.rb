# ========================================
#    Event class
# ========================================

class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :attendances
  has_many :guests, through: :attendances

  validates :admin, :title, :date, :venue, presence: true

  def display
    pastel = Pastel.new
    puts '-' * 40
    puts pastel.yellow(title)
    puts '-' * 40
    puts description
    puts pastel.cyan("\tDate:\t #{date}")
    puts pastel.cyan("\tVenue:\t #{venue}")
  end
end
