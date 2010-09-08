class Waiter < ActiveRecord::Base
  belongs_to :event
  
  before_validation_on_create :set_code
  
  validates_presence_of :code, :event, :email
  
  def position
    Waiter.count(:conditions => [
      'event_id = ? AND created_at < ?', event_id, created_at
    ]) + 1
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
