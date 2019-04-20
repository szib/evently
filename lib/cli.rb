class CLI
  def initialize
    @prompt = TTY::Prompt.new
    @app_name = 'Eventy'
  end

  def login
    name = @prompt.ask("What's your name?: ", default: 'Ivan')
    @guest = Guest.find_or_create_by(name: name)
  end

  def select_mainmenu_item
    menu_items = ['Show my events', 'Manage my events', 'Find new events', 'Quit']
    @prompt.select('What would you like to do?', menu_items)
  end

  def display_current_events
    Terminal.display_logo(@app_name)
    puts 'You are currently attending:'
    events = @guest.reload.events
    if events.count == 0
      Terminal.message('You have not signed up for any events.')
    else
      tp @guest.reload.events.sort_by(&:date), :title, :date, :venue, :num_of_attendees
    end
    puts ''
  end

  def select_new_event
    events = @guest.reload.new_events.sort_by(&:date)
    choices = Event.to_menu_items(events)
    id = @prompt.select('Select an event to continue:', choices, filter: true)
    Event.find(id)
  end

  def select_my_event
    events = @guest.reload.events.sort_by(&:date)
    if events.count == 0
      Terminal.message('You have not signed up for any events.')
    else
      choices = Event.to_menu_items(events)
      id = @prompt.select('Select an event to continue:', choices, filter: true)
      Event.find(id)
    end
  end

  def sign_up?(_event)
    question = 'Are you sure you want to sign up for this event?'
    answer = @prompt.yes?(question, default: false)
  end

  def cancel?(_event)
    question = 'Are you sure you want to cancel your attendance?'
    answer = @prompt.yes?(question, default: false)
  end

  def update_friends(event)
    return unless event.attending?(@guest)

    attendance = Attendance.find_by(guest: @guest, event: event)

    question = "You are bringing #{attendance.friends_to_s}. Would you like to change it?"
    answer = @prompt.yes?(question, default: false)

    if answer == true
      question = 'How many friends would you like to bring?'
      answer = @prompt.ask(question, default: 0) do |q|
        q.validate /^\d$/
        q.messages[:valid?] = 'You can bring up to nine friends.'
      end
      attendance.num_of_extra_guests = answer.to_i
      Terminal.message('Consider it done.')
    else
      Terminal.message('Okay, no problem!')
    end
  end

  def display_guest_list(event)
    guest_list = event.guest_list
    if guest_list.empty?
      Terminal.message 'Noone is coming to this event. Be the first to sign up. :)'
    else
      pastel = Pastel.new
      puts pastel.bright_cyan('-' * 80)
      puts pastel.bright_cyan('Guest list:')
      puts pastel.bright_cyan(guest_list)
      puts pastel.bright_cyan('-' * 80)
    end
  end

  def search_menu
    choices = ['Show attendees', 'Sign up for this event.', 'Back']
    @prompt.select('Choose from the menu:', choices)
  end

  def manage_menu
    choices = ['Show attendees', 'Cancel attendance.', 'Change extra guests', 'Back']
    @prompt.select('Choose from the menu:', choices)
  end

  def find_new_events
    event = select_new_event
    return if event.nil?

    Terminal.clear_terminal
    Terminal.show_in_box(event.event_info)
    menu_item = search_menu

    case menu_item
    when 'Sign up for this event.'
      if sign_up?(event)
        event.toggle_attendance(@guest)
        Terminal.message('Consider it done.')
      else
        Terminal.message('Okay, no problem.')
      end
    when 'Show attendees'
      display_guest_list(event)
    else
      Terminal.message 'Going back!'
    end
  end

  def manage_my_events
    event = select_my_event
    return if event.nil?

    Terminal.clear_terminal
    Terminal.show_in_box(event.event_info)
    menu_item = manage_menu

    case menu_item
    when 'Cancel attendance.'
      if cancel?(event)
        event.toggle_attendance(@guest)
        Terminal.message('Consider it done.')
      else
        Terminal.message('Okay, no problem.')
      end
    when 'Change extra guests'
      update_friends(event)
    when 'Show attendees'
      display_guest_list(event)
    else
      Terminal.message('Going back!')
    end
  end

  def show_mainmenu
    answer = nil
    until answer == 'Quit'
      answer = select_mainmenu_item
      case answer
      when 'Show my events'
        display_current_events
      when 'Manage my events'
        manage_my_events
      when 'Find new events'
        find_new_events
      end
    end
  end

  def run
    Terminal.display_logo(@app_name)
    login
    Terminal.welcome(@guest.name)

    show_mainmenu

    Terminal.bye
  end
end
