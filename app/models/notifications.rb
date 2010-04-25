class Notifications < ActionMailer::Base
  def registration(attendee)
    subject     'Trampoline Registration'
    recipients  attendee.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
    body        :attendee => attendee
  end
  
  def invite(attendee)
    subject     'Trampoline Invitation'
    recipients  attendee.invite_email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
    body        :attendee => attendee
  end
  
  def preoverview(attendee)
    subject     'Trampoline Approaching'
    recipients  attendee.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
    body        :attendee => attendee
  end
end
