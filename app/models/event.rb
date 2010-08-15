class Event < ActiveRecord::Base
  has_many :attendees
  has_many :uninvited_attendees,
    :conditions => "referral_code = ''",
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
      attendees.count >= max_attendees
    else
      uninvited_attendees.count >= (max_attendees / 2)
    end
  end
end