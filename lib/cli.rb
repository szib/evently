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
    menu_items = ['Show my events', 'Manage my events', 'Find new events', 'Quit']
    @prompt.select('What would you like to do?', menu_items)
  end

  def display_current_events
    puts 'You are currently attending:'
    tp @guest.reload.events, :title, :date, :venue
  end

  def select_event
    events = Event.all
    choices = Event.to_menu_items(events)
    id = @prompt.select('Select an event to continue:', choices, filter: true)
    Event.find(id)
  end

  def event_signup(event)
    question = "Would you like to attend this event?"
    answer = @prompt.yes?(question)
    if answer == true
      event.toggle_attendance(@guest)
      puts "Consider it done."
    else
      puts "Okay, no problem!"
    end
  end

  def update_attendance(event)
    if event.guests.include?(@guest)
      question = "You are already attending this event. Would you like to cancel your attendance?"
    else
      question = "Would you like to attend this event?"
    end
    answer = @prompt.yes?(question)
    if answer == true
      event.toggle_attendance(@guest)
      puts "Consider it done."
    else
      puts "Okay, no problem!"
    end
  end

  def update_friends(event)
    return unless event.attending?(@guest)

    attendance = Attendance.find_by(guest: @guest, event: event)

    question = "You are bringing #{attendance.friends_to_s}. Would you like to change it?"
    answer = @prompt.yes?(question)

    if answer == true
      question = "How many friends would you like to bring?"
      answer = @prompt.ask(question) do |q|
        q.validate /^\d$/
        q.messages[:valid?] = 'You can bring up to nine friends.'
      end
      attendance.change_num_of_friends(answer.to_i)
      puts "Consider it done."
    else
      puts "Okay, no problem!"
    end
  end

  def display_guest_list(event)
    pastel = Pastel.new
    attendees = event.attendances.first(5).map { |a| a.guest_name_with_friends }.join(", ")
    if event.attendances.length > 5
      attendees = [attendees, " and many more..."].join()
    end

    puts pastel.green("-" * 60)
    puts pastel.green("Guest list:")
    puts pastel.green(attendees)
    puts pastel.green("-" * 60)
  end

  def display_event(event)
    pastel = Pastel.new
    puts '-' * 60
    puts pastel.yellow(event.title)
    puts '-' * 60

    puts pastel.cyan("Description:\t\t #{event.description}")
    puts pastel.cyan("Date:\t\t #{event.date}")
    puts pastel.cyan("Venue:\t\t #{event.venue}")
    puts pastel.cyan("Attendees:\t\t #{event.num_of_attendees}")

    display_guest_list(event)
  end

  def search_menu
    choices = ["Sign up for this event.", "Back"]
    @prompt.select("Choose from the menu:", choices)
  end

  def manage_menu
    choices = ["Cancel attendance.", "Change extra guests", "Back"]
    @prompt.select("Choose from the menu:", choices)
  end

  def find_new_events
    event = select_event
    display_event(event)

    menu_item = search_menu

    case menu_item
    when "Sign up for this event."
      event_signup(event)
    else
      puts "Going back!"
    end
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
      when 'Manage my events'
        puts 'Mischief managed.'
      when 'Find new events'
        find_new_events
      end
    end
  end
end
