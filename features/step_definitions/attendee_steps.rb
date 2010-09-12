Given /^a registered attendee "([^\"]*)"$/ do |name|
  Attendee.make :name => name
end

When /^"([^"]*)" cancels his attendance$/ do |name|
  Attendee.find_by_name(name).cancel!
end
