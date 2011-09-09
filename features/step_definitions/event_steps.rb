Given /^an event open for registration$/ do
  Event.make! :happens_on => 3.weeks.from_now
end

Given /^the event's first round has passed$/ do
  Event.next.update_attributes(
    :happens_on => 2.weeks.from_now,
    :release_at => 2.weeks.ago,
    :excess_at  => 1.day.ago
  )
end

Given /^a completely sold out event$/ do
  event = Event.make! :happens_on => 1.week.from_now, :max_attendees => 2
  event.max_attendees.times do
    Attendee.make! :event => event
  end
end
