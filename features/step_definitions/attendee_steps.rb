Given /^a registered attendee "([^\"]*)"$/ do |name|
  Attendee.make! :name => name
end

When /^"([^"]*)" cancels his attendance$/ do |name|
  Attendee.find_by_name(name).cancel!
end

When /^"([^"]*)" cancelled his attendance (\d+) days ago$/ do |name, days|
  Timecop.travel Time.zone.now - days.to_i.days
  Attendee.find_by_name(name).cancel!
  Timecop.return
end

When /^PayPal redirects me back after a successful payment for "([^"]*)"$/ do |name|
  attendee = Attendee.find_by_name(name)
  visit confirmed_attendee_path(attendee)
end
