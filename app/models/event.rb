class Event < ApplicationRecord
  has_many :invites
  has_many :waiters
  has_many :attendees
  has_many :active_attendees, lambda {
        where "cancelled_at IS NULL and confirmed = 't'"
      }, :class_name => 'Attendee'
  has_many :uninvited_attendees, lambda {
      where "referral_code = '' and confirmed = 't'"
    }, :class_name => 'Attendee'
  has_many :invited_attendees, lambda {
      where "referral_code <> '' and confirmed = 't'"
    }, :class_name => 'Attendee'

  scope :upcoming, lambda {
    where('happens_on > ?', Time.zone.now.to_date).order(:happens_on) }
  scope :next_and_upcoming, lambda {
    where('happens_on >= ?', Time.zone.now.to_date).order(:happens_on) }
  scope :past, lambda {
    where('happens_on < ?', Time.zone.now.to_date).order(:happens_on) }
  scope :before_excess, lambda { where('excess_at >= now()') }

  def self.upcoming?
    last && last.happens_on > Date.today
  end

  def self.next
    next_and_upcoming.first
  end

  def self.latest
    where('happens_on <= ?', Date.today).order('happens_on DESC').first
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

  def to_param
    "#{id}-#{city.downcase}"
  end
end
