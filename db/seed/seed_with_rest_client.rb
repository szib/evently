# ========================================
#		Seeding database with REST client
# ========================================

def seed_with_rest_client
  api = API.new
  raw_event_data = api.get_flatiron_events
  event_data = api.parse_event_information(raw_event_data)
  event_data.each do |event|
    Event.create(event)
  end
end
