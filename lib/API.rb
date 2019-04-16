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

end
