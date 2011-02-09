Given /^an event open for registration$/ do
  Event.make! :happens_on => 3.weeks.from_now
end

Given /^a completely sold out event$/ do
  event = Event.make! :happens_on => 1.week.from_now, :max_attendees => 2
  event.max_attendees.times do
    Attendee.make! :event => event
  end
end
