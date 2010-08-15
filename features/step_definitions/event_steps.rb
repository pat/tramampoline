Given /^an event open for registration$/ do
  Event.make :happens_on => 3.weeks.from_now
end
