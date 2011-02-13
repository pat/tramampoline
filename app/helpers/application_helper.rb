# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TronprintHelper
  
  def next_event
    @next_event ||= Event.next
  end
  
  def referral_link(attendee)
    accept_url(attendee.invite_code)
  end
  
  def all_released?
    Time.zone.now >= next_event.excess_at
  end
  
  def team
    ['Aida', 'Mel', 'Pat', 'Steve'].sort_by { rand }
  end
  
  def team_string
    array = team.clone
    array[0..2].join(', ') + " and #{array.last}"
  end
end
