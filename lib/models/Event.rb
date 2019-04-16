# ========================================
#    Event class
# ========================================

class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :attendances
  has_many :guests, through: :attendances

  validates :admin, :title, :date, :venue, presence: true

  def num_of_attendees
    # including extra friends
    self.attendances.map { |a| a.number_of_guests }.sum
  end

  def display
    pastel = Pastel.new
    puts '-' * 40
    puts pastel.yellow(title)
    puts '-' * 40
    puts description
    puts pastel.cyan("\tDate:\t #{date}")
    puts pastel.cyan("\tVenue:\t #{venue}")
  end

  def to_menu_item
    # returns a hash for prompt.select
  end

end
