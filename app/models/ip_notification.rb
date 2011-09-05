require 'open-uri'

class IPNotification < ActiveRecord::Base
  PayPalUrl  = 'https://www.paypal.com/cgi-bin/webscr'
  Business   = 'pat@freelancing-gods.com'

  class InvalidNotificationError < StandardError; end

  belongs_to :attendee

  attr_accessor :request

  before_create :set_attributes_from_request, :on => :create

  def self.process(request)
    notification = create! :request => request
    notification.process! if notification.legit?
    notification.legit?
  end

  def process!
    raise InvalidNotificationError unless legit?

    case transaction_type
    when 'express_checkout', 'send_money', 'web_accept'
      attendee.confirm!
    end
  end

  def legit?
    verified? && correct_business?
  end

  def verified?
    @verified ||= (self.status == 'VERIFIED')
  end

  def correct_business?
    [Business].include?(business)
  end

  private

  def set_attributes_from_request
    self.business               = request.params['business']
    self.receiver_email         = request.params['receiver_email']
    self.transaction_type       = request.params['txn_type']
    self.transaction_id         = request.params['txn_id']
    self.attendee_id            = request.params['custom'].to_i
    self.amount                 = request.params['auth_amount'].to_f
    self.payment_date           = convert_date request.params['payment_date']
    self.verification_signature = request.params['verify_sign']
    self.query_string           = request.body.read
    self.status                 = open(verification_url).read
  end

  def verification_url
    "#{PayPalUrl}?cmd=_notify-validate&#{query_string}"
  end

  def convert_date(string)
    return nil if string.blank?

    match = string.match(/(\d+):(\d+):(\d+) (\w{3}) (\d+), (\d{4}) (\w\w\w)/)
    time = Time.zone.local match[6].to_i, match[4],      match[5].to_i,
                           match[1].to_i, match[2].to_i, match[3].to_i

    case match[7]
    when /PDT/
      time + 7.hours + Time.zone.utc_offset
    when /PST/
      time + 8.hours + Time.zone.utc_offset
    end
  end
end
