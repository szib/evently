# ========================================
#    Seeding database with REST client
# ========================================

def seed_with_rest_client
  if API.api_key_present?
    API.import_events
  else
    puts 'No API key detected. Quiting...'
  end
end
