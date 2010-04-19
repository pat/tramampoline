class Notifications < ActionMailer::Base
  def tickets(subscriber)
    subject     'Trampoline Tickets Available!'
    recipients  subscriber.email
    from        'Pat Allan <pat@freelancing-gods.com>'
    sent_on     Time.now
  end
end
