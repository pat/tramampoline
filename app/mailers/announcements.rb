class Announcements < ActionMailer::Base
  helper :application

  default :from => 'Trampoline Team <team@trampolineday.com>'

  def tickets(subscriber)
    mail :to => subscriber.email, :subject => 'Trampoline Tickets Available!'
  end

  def more(subscriber)
    mail :to => subscriber.email, :subject => 'More Tickets for Trampoline!'
  end

  def more_soon(subscriber)
    mail :to => subscriber.email, :subject => 'More Tickets for Trampoline!'
  end

  def tramp4(subscriber)
    mail :to => subscriber.email, :subject => 'Trampoline Melbourne'
  end
end
