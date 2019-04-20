class CLI
  def initialize
    @prompt = TTY::Prompt.new
    @app_name = 'Eventy'
  end

  def login
    name = @prompt.ask("What's your name?: ", default: 'Ivan')
    @guest = Guest.find_or_create_by(name: name)
  end

  def confirm(question, default = false)
    answer = @prompt.yes?(question, default: default)
  end

  def select_mainmenu_item
    menu_items = ['Show my events', 'Manage my events', 'Find new events', 'Quit']
    @prompt.select('What would you like to do?', menu_items)
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

  def update_friends(event)
    return unless @guest.attending?(event)

    attendance = Attendance.find_by(guest: @guest, event: event)

    Terminal.message event.attendance_info_of(@guest)

    question = 'Would you like to change it?'
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
    guest_list = event.reload.guest_list
    if guest_list.empty?
      Terminal.message 'Noone is coming to this event. Be the first to sign up. :)'
    else
      pastel = Pastel.new
      puts pastel.bright_cyan('-' * 80)
      puts pastel.bright_cyan('Guest list:')
      puts pastel.bright_cyan(guest_list)
      puts pastel.bright_cyan('-' * 80)
    end
    @prompt.keypress('Press space or enter to continue', keys: %i[space return])
  end

  def select_findevent_item
    choices = ['Show attendees', 'Sign up for this event.', 'Back']
    @prompt.select('Choose from the menu:', choices)
  end

  def select_managemenu_item
    choices = ['Show attendees', 'Cancel attendance.', 'Change extra guests', 'Back']
    @prompt.select('Choose from the menu:', choices)
  end

  def change_attendance(event)
    event.reload
    Terminal.message event.attendance_info_of(@guest)

    question = if @guest.attending?(event)
                 'Do you want cancel your attendance?'
               else
                 'Do you want to sign up for this event?'
               end

    confirmed = @prompt.yes?(question, default: false)

    if confirmed
      event.toggle_attendance(@guest)
      Terminal.message('Consider it done.')
    else
      Terminal.message('Okay, no problem.')
    end
  end

  # ========================================
  #    MAIN MENU ITEMS
  # ========================================
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

  def find_event
    event = select_new_event
    return if event.nil?

    menu_item = nil
    until menu_item == 'Back'
      Terminal.clear_terminal
      Terminal.show_in_box(event.event_info)
      menu_item = select_findevent_item

      case menu_item
      when 'Sign up for this event.'
        change_attendance(event)
      when 'Show attendees'
        display_guest_list(event)
      end
    end

    Terminal.message 'Going back!'
  end

  def manage_my_events
    event = select_my_event
    return if event.nil?

    menu_item = nil
    until menu_item == 'Back'
      Terminal.clear_terminal
      Terminal.show_in_box(event.event_info)
      menu_item = select_managemenu_item

      case menu_item
      when 'Cancel attendance.'
        change_attendance(event)
      when 'Change extra guests'
        update_friends(event)
      when 'Show attendees'
        display_guest_list(event)
      end
    end

    Terminal.message('Going back!')
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
        find_event
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
