class Notifications < ActionMailer::Base
  helper :application

  default :from => 'Trampoline Team <team@trampolineday.com>'

  def registration(attendee)
    @attendee = attendee
    @event    = attendee.event

    mail :to => attendee.email, :subject => 'Trampoline Registration'
  end

  def invite(attendee)
    @attendee = attendee
    @event    = attendee.event

    mail :to => attendee.invite_email, :subject => 'Trampoline Invitation'
  end

  def invite_reminder(attendee)
    @attendee = attendee
    @event    = attendee.event

    mail :to => attendee.email, :subject => 'Trampoline Invitation Reminder'
  end

  def preoverview(attendee)
    @attendee = attendee
    @event    = attendee.event

    mail :to => attendee.email, :subject => 'Trampoline Approaching'
  end

  def preparing(attendee)
    @attendee = attendee
    @event    = attendee.event

    mail :to => attendee.email, :subject => 'Preparing for Trampoline'
  end

  def final_reminder(attendee)
    @event    = attendee.event

    mail :to => attendee.email, :subject => 'Trampoline: The Final Reminder'
  end

  def wrapup(attendee)
    @event    = attendee.event

    mail :to => attendee.email, :subject => 'Trampoline: Wrapping Up'
  end

  def waiting_over(waiter)
    @waiter = waiter
    @event  = waiter.event

    mail :to => waiter.email, :subject => 'Trampoline Waiting List: The Waiting is Over'
  end

  def reminder(event, email)
    @event = event

    mail :to => email, :subject => 'Trampoline Adelaide 3 Approaches'
  end
end
