Given /^an invite "([^"]*)" for (\d+) people$/ do |description, amount|
  Invite.make :description => description, :amount => amount.to_i
end
