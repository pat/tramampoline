class Waiter < ActiveRecord::Base
  belongs_to :event
  belongs_to :attendee
  
  before_validation_on_create :set_code
  
  validates_presence_of :code, :event, :email
  
  named_scope :uninvited,
    :conditions => 'invited_at IS NULL AND closed = FALSE',
    :order      => 'created_at ASC'
  named_scope :unclosed,
    :conditions => [
      'invited_at IS NOT NULL',
      "invited_at < (current_timestamp - interval '24 hours')",
      'closed = FALSE'
    ].join(' AND ')
  
  def self.invite!(event)
    event.waiters.uninvited.first.invite! unless event.waiters.uninvited.empty?
  end
  
  def self.close_and_reinvite
    Waiter.unclosed.each do |waiter|
      waiter.close!
    end
  end
  
  def position
    Waiter.count(:conditions => [
      'event_id = ? AND created_at < ?', event_id, created_at
    ]) + 1
  end
  
  def invite!
    update_attributes(:invited_at => Time.zone.now)
    Notifications.deliver_waiting_over self
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
    
    set_code if Waiter.find_by_code(code)
  end
  
  def generate_hash(string)
    Digest::SHA1.hexdigest(string)
  end
end
