Given /^"([^"]*)" is waiting$/ do |email|
  Waiter.make :email => email
end

When /^the waiting list is progressed$/ do
  Waiter.close_and_reinvite
end
