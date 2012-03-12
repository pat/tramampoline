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
  visit confirmed_event_attendee_path(attendee.event, attendee)
end

When /^PayPal confirms the payment for "([^"]*)"$/ do |name|
  FakeWeb.register_uri :get, /^https:\/\/www\.paypal\.com\/cgi-bin\/webscr/,
    :body => 'VERIFIED'
  attendee = Attendee.find_by_name(name)
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
