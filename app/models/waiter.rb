class Waiter < ActiveRecord::Base
  belongs_to :event
  belongs_to :attendee
  has_one :invite, :as => :parent

  before_validation :set_code, :on => :create

  validates_presence_of :code, :event, :email

  scope :uninvited, lambda {
    where('invited_at IS NULL AND closed = FALSE').
    order('created_at ASC')
  }
  scope :unclosed, lambda {
    where('invited_at IS NOT NULL').
    where("invited_at < (current_timestamp - interval '24 hours')").
    where(['closed = ?', false])
  }

  def self.invite!(event)
    event.waiters.uninvited.first.invite! unless event.waiters.uninvited.empty?
  end

  def self.close_and_reinvite
    Waiter.unclosed.each do |waiter|
      waiter.close!
    end
  end

  def position
    Waiter.where(['event_id = ? AND created_at < ?', event_id, created_at]).
      count + 1
  end

  def invite!
    create_invite(
      :event       => self.event,
      :amount      => 1,
      :description => "Waiting list invite for #{email}",
      :expires_at  => 1.day.from_now
    )
    update_attributes(:invited_at => Time.zone.now)

    Notifications.waiting_over(self).deliver_now
  end

  def invited?
    !invited_at.nil?
  end

  def close!
    update_attributes(:closed => true)
    Waiter.invite!(event) if attendee.nil?
  end

  private

  def set_code
    self.code = generate_hash("--#{Time.now.utc}--#{email}--")[0..7]

    set_code if Waiter.find_by(:code => code)
  end

  def generate_hash(string)
    Digest::SHA1.hexdigest(string)
  end
end
