# ========================================
#		Seeding database with minimal dataset
# ========================================

def seed_with_minimal_dataset
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
end