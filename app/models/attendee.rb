require 'digest/sha1'

class Attendee < ActiveRecord::Base
  validates_presence_of :name, :email, :invite_code
  
  before_validation_on_create :set_invite_code
  after_create :send_attendee_email, :send_invited_email
  
  belongs_to :event
  belongs_to :invited,
    :class_name  => 'Attendee',
    :primary_key => 'referral_code',
    :foreign_key => 'invite_code'
  belongs_to :inviter,
    :class_name  => 'Attendee',
    :primary_key => 'invite_code',
    :foreign_key => 'referral_code'
  
  def self.with_code(code)
    find_by_invite_code(code)
  end
    
  def inviting?
    invite_email.present?
  end
  
  def invited?
    referral_code.present?
  end
  
  def cancel!(time = Time.zone.now)
    update_attributes(:cancelled_at => time)
  end
  
  private
  
  def set_invite_code
    self.invite_code = generate_hash("--#{Time.now.utc}--#{email}--")[0..7]
    
    set_invite_code if Attendee.with_code(invite_code) || Invite.with_code(invite_code)
  end
  
  def generate_hash(string)
    Digest::SHA1.hexdigest(string)
  end
  
  def send_attendee_email
    Notifications.deliver_registration self
  end
  
  def send_invited_email
    return if invited? || !inviting? || Time.zone.now >= event.excess_at
    
    Notifications.deliver_invite self
  end
end
