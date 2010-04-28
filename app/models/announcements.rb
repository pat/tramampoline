class Announcements < ActionMailer::Base
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
end
