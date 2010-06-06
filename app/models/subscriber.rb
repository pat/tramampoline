class Subscriber < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def self.cleanup!
    emails = connection.select_values("SELECT DISTINCT email FROM subscribers")
    emails.each do |email|
      subscribers = Subscriber.find_all_by_email(email)
      next if email.length <= 1
      
      named   = subscribers.select { |sub| sub.name.present? }
      unnamed = subscribers - named
      
      if named.blank?
        subscribers[1..-1].each { |sub| sub.destroy }
      else
        unnamed.each { |sub| sub.destroy }
      end
      
      named[0..-2].each { |sub| sub.destroy } if named.length > 1
    end
  end
end
