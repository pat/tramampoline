require 'machinist/active_record'
require 'faker'

Machinist.configure do |config|
  config.cache_objects = false
end

Attendee.blueprint do
  name  { Faker::Name.name }
  email { Faker::Internet.email }
  event { Event.next || Event.make! }
  invite { Invite.make!(:event => object.event) }
end

Event.blueprint do
  city          { "Melbourne" }
  venue         { "Donkey Wheel House" }
  happens_on    { Date.today + 2.months }
  release_at    { object.happens_on - 1.month }
  excess_at     { object.happens_on - 2.weeks }
  max_attendees { 100 }
  organisers    { 'Pat, Mel, Aida, Steve' }
end

Invite.blueprint do
  description { "Special Guest Pass" }
  event       { Event.next || Event.make! }
  amount      { 1 }
end

IPNotification.blueprint do
  business               { 'email@domain.com' }
  receiver_email         { object.business }
  transaction_type       { 'send_money' }
  transaction_id         { 'I-3YTCCUFV7GK6' }
  attendee               { Attendee.make! }
  amount                 { 25.00 }
  payment_date           { Time.zone.local(2011, 9, 8, 19, 1, 31) }
  verification_signature { 'AFcWxV21C7fd0v3bYYYRCpSSRl31AAnihQSZwCp6N8g3NYySz6.0Wuhu' }
  query_string           { 'business=email@domain.com&txn_type=send_money' }
  status                 { 'VERIFIED' }
end

Subscriber.blueprint do
  email { Faker::Internet.email }
end

Waiter.blueprint do
  name  { Faker::Name.name }
  email { Faker::Internet.email }
  event { Event.next || Event.make! }
end
