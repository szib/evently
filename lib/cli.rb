class CLI
  def initialize
    @pastel = Pastel.new
    @prompt = TTY::Prompt.new

    @app_name = 'Eventy'
  end

  def display_logo
    font = TTY::Font.new('doom')
    title = font.write(@app_name)
    puts @pastel.yellow(title)
  end

  def find_or_create_user
    name = @prompt.ask("What's your name?: ")
    @guest = Guest.find_or_create_by(name: name)
  end

  def welcome
    puts "Welcome, #{@guest.name}!"
  end

  def show_menu
    menu_items = ['Show my events', 'Search for new events', 'Quit']
    @prompt.select('What would you like to do?', menu_items)
  end

  def display_current_events
    puts 'You are currently attending:'
    tp @guest.events, :title, :date, :venue, :cancelled
  end

  def search_for_new_events
    events = Event.all.reject { |event| event.guests.include?(@guest) }
    choices = Event.to_menu_items(events: events)
    id = @prompt.select('Select an event:', choices, filter: true)
    Event.find(id).display
  end

  def run
    display_logo
    find_or_create_user
    welcome

    answer = nil
    until answer == 'Quit'
      answer = show_menu
      case answer
      when 'Show my events'
        display_current_events
      when 'Search for new events'
        search_for_new_events
      end
    end
  end
end
