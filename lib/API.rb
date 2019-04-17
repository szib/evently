class API
  URL = "https://www.eventbriteapi.com/v3/events/search/?organizer.id=17393370241"

  def self.api_key_present?
    ENV.key?("EVENTBRITE_API_KEY")
  end

  def self.import_events
    raw_event_data = retrive_event_data_from_eventbrite
    event_data = parse_event_information(raw_event_data)
    save_to_database(event_data)
  end
  
  private

  def self.url_with_token
    "#{URL}&token=#{ENV["EVENTBRITE_API_KEY"]}"
  end

  def self.retrive_event_data_from_eventbrite
    response = RestClient.get(url_with_token)
    hash = JSON.parse(response)
    hash["events"]
  end

  def self.get_venue_name(venue_id)
    venue_url = "https://www.eventbriteapi.com/v3/venues/#{venue_id}/?token=#{ENV["EVENTBRITE_API_KEY"]}"
    response = RestClient.get(venue_url)
    hash = JSON.parse(response)
    venue_address = hash["address"]["localized_address_display"]
    venue_name = hash["name"]
    "#{venue_name}, #{venue_address}"
  end

  def self.parse_event_information(raw_event_data)
    event_data = []
    raw_event_data.each do |event|
      event_hash = {}

      event_hash[:title] = event["name"]["text"]
      event_hash[:description] = event["description"]["text"]
      event_hash[:date] = event["start"]["local"]
      event_hash[:venue] = get_venue_name(event["venue_id"])

      event_data << event_hash
    end
    event_data
  end

  def self.save_to_database(data)
    data.each { |event| Event.create(event) }
  end


end
