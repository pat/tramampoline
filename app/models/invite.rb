class Invite < ActiveRecord::Base
  belongs_to :event
  has_many :attendees,
    :class_name  => 'Attendee',
    :primary_key => 'code',
    :foreign_key => 'referral_code'
  
  before_validation :set_code, :on => :create
  
  validates_presence_of :code, :event
  
  def self.with_code(code)
    find_by_code(code)
  end
  
  def consumed?
    attendees.count >= amount
  end
  
  private
  
  def set_code
    self.code = generate_hash("--#{Time.now.utc}--#{description}--")[0..7]
    
    set_code if Attendee.with_code(code) || Invite.with_code(code)
  end
  
  def generate_hash(string)
    Digest::SHA1.hexdigest(string)
  end
end
