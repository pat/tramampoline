Given /^"([^"]*)" is waiting$/ do |email|
  Waiter.make :email => email
end
