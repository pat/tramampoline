class Event < ActiveRecord::Base
  has_many :invites
  has_many :waiters
  has_many :attendees
  has_many :active_attendees,
    :conditions => "cancelled_at IS NULL",
    :class_name => 'Attendee'
  has_many :uninvited_attendees,
    :conditions => "referral_code = ''",
    :class_name => 'Attendee'
  has_many :invited_attendees,
    :conditions => "referral_code <> ''",
    :class_name => 'Attendee'
  
  def self.upcoming?
    last && last.happens_on > Date.today
  end
  
  def self.next
    find :first,
      :conditions => ['happens_on > ?', Date.today],
      :order => 'happens_on ASC'
  end
  
  def self.upcoming
    find :all,
      :conditions => ['happens_on > ?', Date.today],
      :order => 'happens_on ASC'
  end
  
  def self.past
    find :all,
      :conditions => ['happens_on <= ?', Date.today],
      :order => 'happens_on ASC'
  end
  
  def on_sale?
    release_at <= Time.zone.now
  end
  
  def excess_on_sale?
    excess_at <= Time.zone.now
  end
  
  def sold_out?
    if excess_on_sale?
      attendees.active_or_cancelled_after(excess_at).count >= max_attendees
    else
      uninvited_attendees.count >= (max_attendees / 2)
    end
  end
  
  def initial_sold_out?
    on_sale? && sold_out? && !excess_on_sale?
  end
end
