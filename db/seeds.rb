# ========================================
#    Seedin database
# ========================================

require_all 'db/seed'

def show_menu
  prompt = TTY::Prompt.new

  choice = prompt.enum_select("How do you want to seed the database?") do |menu|
    menu.choice 'Minimal dataset', 1
    menu.choice 'Faker gem', 2
    menu.choice 'Pulling data from Eventbrite', 3
  end

  case choice
  when 1
    seed_with_minimal_dataset
  when 2
    seed_with_faker
  when 3
    seed_with_rest_client
  end
end

show_menu