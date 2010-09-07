require 'machinist/active_record'
require 'faker'

Attendee.blueprint do
  name  { Faker::Name.name }
  email { Faker::Internet.email }
  event { Event.next || Event.make }
end

Event.blueprint do
  city          { "Melbourne" }
  venue         { "Donkey Wheel House" }
  happens_on    { Date.today + 2.months }
  release_at    { object.happens_on - 1.month }
  excess_at     { object.happens_on - 2.weeks }
  max_attendees { 100 }
end

Invite.blueprint do
  description { "Special Guest Pass" }
  event       { Event.next || Event.make }
  amount      { 1 }
end

Subscriber.blueprint do
  email { Faker::Internet.email }
end
