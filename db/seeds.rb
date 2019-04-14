# ========================================
#    Seedin database with Faker gem
# ========================================

# CONFIGURATION
Faker::Config.random = Random.new(42)
Faker::Config.locale = 'en-GB'

num_of_admins = 5
num_of_guests = 50
num_of_events = 30
num_of_attendance = 30

#  --- DO NOT EDIT BELOW THIS LINE ---
num_of_admins.times { Admin.create(name: Faker::Name.unique.name) }
num_of_guests.times { Guest.create(name: Faker::Name.unique.name_with_middle) }

num_of_events.times do
  admin = Admin.find(rand(1..num_of_admins))
  Event.create(
    title: "#{admin.name}'s #{Faker::Verb.ing_form} event",
    description: Faker::Lorem.sentences(3).join(' '),
    date: Faker::Date.forward(30),
    venue: Faker::Address.full_address,
    admin: admin
  )
end

num_of_attendance.times do |_idx|
  extra_guest_is_coming = rand(1..4) % 4 == 0
  Attendance.create(
    guest: Guest.find(rand(1..num_of_guests)),
    event: Event.find(rand(1..num_of_events)),
    num_of_extra_guests: extra_guest_is_coming ? rand(1..5) : 0
  )
end
