class Subscriber < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email
  
  after_create  :add_to_mailchimp
  after_destroy :remove_from_mailchimp
  
  MailChimpList = '9464fe6e3a'
  
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
  
  private
  
  def add_to_mailchimp
    return unless Rails.env.production?
    
    hominid.list_subscribe MailChimpList, email, [], 'html', false, true, true, false
  end
  
  def remove_from_mailchimp
    return unless Rails.env.production?
    
    hominid.list_unsubscribe MailChimpList, email, false, true, true
  end
  
  def hominid
    @hominid ||= Hominid::API.new('17e6699ec030e478d0be4f6f91110353-us2')
  end
end
