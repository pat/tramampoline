Given /^a registered attendee "([^\"]*)"$/ do |name|
  Attendee.make :name => name
end
