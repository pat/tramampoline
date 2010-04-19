# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def referral_link(attendee)
    accept_url(attendee.invite_code)
  end
  
  def all_released?
    Time.now >= Time.local(2010, 4, 29, 10, 0)
  end
  
  def before_launch?
    Time.now < Time.local(2010, 4, 20, 10, 0)
  end
end
