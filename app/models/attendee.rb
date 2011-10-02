require 'digest/sha1'

class Attendee < ActiveRecord::Base
  validates_presence_of :name, :email, :slug
  validate :confirm_referral_code

  before_validation :set_slug,      :on => :create
  before_validation :set_confirmed, :on => :create
  after_create :add_invite
  after_create :send_emails
  after_update :send_emails_if_confirmed

  has_one :invite, :as => :parent
  belongs_to :event
  belongs_to :referral_invite,
    :class_name  => 'Invite',
    :primary_key => 'code',
    :foreign_key => 'referral_code'

  scope :active_or_cancelled_after, lambda { |date|
    where([
      '(cancelled_at IS NULL OR cancelled_at >= ?) AND confirmed = ?',
      date, true
    ])
  }
  scope :active, where('cancelled_at IS NULL AND confirmed = ?', true)

  def cancel!(time = Time.zone.now)
    update_attributes(:cancelled_at => time)
    Waiter.invite! event
  end

  def confirm!
    update_attributes(:confirmed => true)
  end

  def inviting?
    invite.present? && invite_email.present?
  end

  def invited?
    referral_invite.present?
  end

  private

  def set_slug
    self.slug = generate_hash("--#{Time.now.utc}--#{email}--")[0..7]

    set_slug if Attendee.find_by_slug(slug)
  end

  def generate_hash(string)
    Digest::SHA1.hexdigest(string)
  end

  def set_confirmed
    self.confirmed = true if invited? || event.excess_on_sale?
  end

  def confirm_referral_code
    if referral_code.present? && referral_invite.nil?
      errors.add(:referral_code, 'is invalid')
    end
  end

  def send_emails
    return unless confirmed?

    Notifications.registration(self).deliver

    if invite.present? && invite_email.present?
      Notifications.invite(self).deliver
    end
  end

  def send_emails_if_confirmed
    send_emails if confirmed? && confirmed_changed?
  end

  def add_invite
    return unless Time.zone.now < event.excess_at && referral_code.blank?

    create_invite(
      :event       => self.event,
      :amount      => 1,
      :description => "Invite from #{name}"
    )
  end
end
