class Notifications < ActionMailer::Base
  helper :application
  
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
  
  def invite_reminder(attendee)
    subject     'Trampoline Invitation Reminder'
    recipients  attendee.email
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
  
  def preparing(attendee)
    subject     'Preparing for Trampoline'
    recipients  attendee.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
    body        :attendee => attendee
  end
  
  def final_reminder(attendee)
    subject     'Trampoline: The Final Reminder'
    recipients  attendee.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
  end
  
  def wrapup(attendee)
    subject     'Trampoline: Wrapping Up'
    recipients  attendee.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
  end
  
  def waiting_over(waiter)
    subject     'Trampoline Waiting List: The Waiting is Over'
    recipients  waiter.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
    body        :waiter => waiter
  end
end
