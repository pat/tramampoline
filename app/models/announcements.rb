class Announcements < ActionMailer::Base
  helper :application
  
  def tickets(subscriber)
    subject     'Trampoline Tickets Available!'
    recipients  subscriber.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
  end
  
  def more(subscriber)
    subject     'More Tickets for Trampoline!'
    recipients  subscriber.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
  end
  
  def tramp4(subscriber)
    subject     'Trampoline Melbourne'
    recipients  subscriber.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
  end
end
