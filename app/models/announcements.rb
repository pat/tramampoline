class Announcements < ActionMailer::Base
  def tickets(subscriber)
    subject     'Trampoline Tickets Available!'
    recipients  subscriber.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.zone.now
  end
end
