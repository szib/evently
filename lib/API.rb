class API
  URL = "https://www.eventbriteapi.com/v3/events/search/?organizer.id=17393370241"

  def url_with_token
    "#{URL}&token=#{ENV["EVENTBRITE_API_KEY"]}"
  end

  def get_flatiron_events
    response = RestClient.get(url_with_token)
    hash = JSON.parse(response)
    hash["events"]
  end

  def parse_event_information(raw_event_data)
    event_data = []
    raw_event_data.each do |event|
      event_hash = {}

      event_hash[:title] = event["name"]["text"]
      event_hash[:description] = event["description"]["text"]
      event_hash[:date] = event["start"]["local"]
      event_hash[:venue_id] = event["venue_id"]

      event_data << event_hash
    end
    binding.pry
    event_data
  end

end
