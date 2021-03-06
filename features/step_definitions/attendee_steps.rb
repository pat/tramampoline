Given /^a registered attendee "([^\"]*)"$/ do |name|
  Attendee.make! :name => name
end

When /^"([^"]*)" cancels his attendance$/ do |name|
  Attendee.find_by(:name => name).cancel!
end

When /^"([^"]*)" cancelled his attendance (\d+) days ago$/ do |name, days|
  Timecop.travel Time.zone.now - days.to_i.days
  Attendee.find_by(:name => name).cancel!
  Timecop.return
end

When /^PayPal redirects me back after a successful payment for "([^"]*)"$/ do |name|
  attendee = Attendee.find_by(:name => name)
  visit confirmed_event_attendee_path(attendee.event, attendee)
end

When /^PayPal confirms the payment for "([^"]*)"$/ do |name|
  stub_request(:get, /^https:\/\/www\.paypal\.com\/cgi-bin\/webscr/).
    to_return(body: 'VERIFIED')

  attendee = Attendee.find_by(:name => name)
  post ipns_path, {
    :business       => IPNotification::Business,
    :receiver_email => IPNotification::Business,
    :txn_type       => 'send_money',
    :txn_id         => 'I-3YTCCUFV7GK6',
    :custom         => attendee.id.to_s,
    :amount         => 25.00,
    :payment_date   => '19:01:31 Sep 8, 2011 PDT',
    :verify_sign    => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AAnihQSZwCp6N8g3NYySz6.0Wuhu'
  }
end

When /^PayPal confirms the payment from "([^"]*)" for the (\w+) event$/ do |name, city|
  stub_request(:get, /^https:\/\/www\.paypal\.com\/cgi-bin\/webscr/).
    to_return(body: 'VERIFIED')

  event    = Event.find_by(:city => city)
  attendee = event.attendees.find_by(:name => name)
  post ipns_path, {
    :business       => IPNotification::Business,
    :receiver_email => IPNotification::Business,
    :txn_type       => 'send_money',
    :txn_id         => 'I-3YTCCUFV7GK6',
    :custom         => attendee.id.to_s,
    :amount         => 25.00,
    :payment_date   => '19:01:31 Sep 8, 2011 PDT',
    :verify_sign    => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AAnihQSZwCp6N8g3NYySz6.0Wuhu'
  }
end

Then /^I should have an email for the (\w+) event$/ do |city|
  event = Event.find_by(:city => city)
  ActionMailer::Base.deliveries.select { |mail|
    mail.subject == 'Trampoline Registration'
  }.detect { |mail|
    mail.html_part.body =~ /\/events\/#{event.to_param}\//
  }.should_not be_nil
end
