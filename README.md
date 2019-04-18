# Evently

## Short description
Eventy is a handy app where guests can see and manage events that they are interested in. A guest can sign up for new events as well as see events they’ve signed up for already all within their terminal. Other features include seeing guests that are already attending the event, updating how many guests you are bringing and cancelling your attendance at an event. We used the Eventbrite API to access events at Flatiron school and seed our database with live examples.

## Install instructions
1. Clone the repository
2. Run `bundle install`
3. Setup database
    - Run `rake db:setup`
    - Choose seeding method
      - Small set of fixed data
      - Larger amount generated data
      - Pulling Flatiron School events from Eventbrite
4. Run `rake run`

**Note:** Seeding with real Flatiron School events from Eventbrite requires Eventbrite API key. 
Go to [Eventbrite API](https://www.eventbrite.com/platform), login to your Eventbrite account and request a key. 
Create a .env file in the root directory.
Save your key as `EVENTBRITE_API_KEY=<your_api_key>`

## Contributors guide

1. Fork it
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Add some feature`
4. Push to the branch `git push origin my-new-feature`
5. Create a new Pull Request

### Ideas

- Search for event organiser and pull their data from Eventbrite
- Search events by venue, location
- Interface for admins
- Notifying users by text message about upcoming events (Nexmo, AWS SNS)


## License
Copyright 2019 Rebecca Huseyin and Ivan Szebenszki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
