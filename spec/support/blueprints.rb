require 'machinist/active_record'
require 'faker'

Attendee.blueprint do
  name  { Faker::Name.name }
  email { Faker::Internet.email }
end

Subscriber.blueprint do
  email { Faker::Internet.email }
end
