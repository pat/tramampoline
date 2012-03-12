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

Given /^an event in (\w+) that is on sale$/ do |city|
  Event.make! :happens_on => 3.weeks.from_now, :city => city
end

When /^I register for the (\w+) event$/ do |city|
  event = Event.find_by_city(city)

  with_scope("\"#event-#{event.id}\"") { click_link 'Register' }
  fill_in 'Name', :with => 'Steve Hopkins'
  fill_in 'Email Address', :with => 'steve@thesquigglyline.com'
  click_button 'Continue'
end
