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
  # pastel = Pastel.new
  # message = pastel.yellow(":spinner") + pastel.cyan(" Seeding ...")
  # spinner = TTY::Spinner.new(message, format: :bouncing_ball)
  # spinner.auto_spin

  case choice
  when 1
    seed_with_minimal_dataset
  when 2
    seed_with_faker
  when 3
    seed_with_rest_client
  end

  # spinner.stop('Done!')
end

show_menu
