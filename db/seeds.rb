# ========================================
#    Seedin database with Faker gem
# ========================================

# CONFIGURATION
Faker::Config.random = Random.new(42)
Faker::Config.locale = 'en-GB'

num_of_admins = 0
num_of_guests = 0
num_of_events = 0
num_of_attendance = 0

admin = Admin.create(name: 'Admin')
ivan = Guest.create(name: 'Ivan')
rebecca = Guest.create(name: 'Rebecca')
e1 = Event.create(title: 'Title 1', venue: 'V1', date: Faker::Date.forward(30), admin: admin)
e2 = Event.create(title: 'Title 2', venue: 'V1', date: Faker::Date.forward(30), admin: admin)
e3 = Event.create(title: 'Title 3', venue: 'V2', date: Faker::Date.forward(30), admin: admin)
e4 = Event.create(title: 'Title 4', venue: 'V2', date: Faker::Date.forward(30), admin: admin)
a1 = Attendance.create(event: e1, guest: ivan)
a2 = Attendance.create(event: e2, guest: ivan)
a3 = Attendance.create(event: e1, guest: rebecca)
a4 = Attendance.create(event: e3, guest: rebecca)

#  --- DO NOT EDIT BELOW THIS LINE ---
num_of_admins.times { Admin.create(name: Faker::Name.unique.name) }
num_of_guests.times { Guest.create(name: Faker::Name.unique.name_with_middle) }

num_of_events.times do
  # admin = Admin.find(rand(1..num_of_admins))
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
